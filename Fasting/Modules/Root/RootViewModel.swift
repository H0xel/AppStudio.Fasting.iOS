//  
//  RootViewModel.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies
import RxSwift

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.fastingService) private var fastingService

    @Published var currentTab: AppTab = .fasting
    @Published var rootScreen: RootScreen = .launchScreen

    var router: RootRouter!

    private let disposeBag = DisposeBag()

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
    }

    func initialize() {
        initializeForceUpdateIfNeeded()
    }

    func requestIdfa() {
        idfaRequestService.requestIDFATracking()
    }

    func openAppStore(_ applink: String) {
        router.presentAppStore(applink)
    }

    var fastingScreen: some View {
        router.fastingScreen
    }

    var onboardingScreen: some View {
        OnboardingRoute(navigator: router.navigator, input: .init(), output: { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.storageService.onboardingIsFinished = true
                self?.fastingParametersInitializer.initialize()
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.rootScreen = .fasting
                }
            }
        })
        .view
    }

    var profileScreen: some View {
        router.profileScreen
    }

    var paywallScreen: some View {
        router.paywallScreen
    }

    private func initializeForceUpdateIfNeeded() {
        appCustomization.forceUpdateAppVersion
            .flatMap(with: self) { this, version -> Observable<(shouldShowForceUpdate: Bool, appLink: String)> in
                this.appCustomization.appStoreLink.map {
                    (shouldShowForceUpdate: !Bundle.lessOrEqualToCurrentVersion(version), appLink: $0)
                }
            }
            .distinctUntilChanged(at: \.shouldShowForceUpdate)
            .asDriver()
            .drive(with: self) { this, args in
                if args.shouldShowForceUpdate {
                    this.rootScreen = .forceUpdate(args.appLink)
                } else {
                    this.rootScreen = this.storageService.onboardingIsFinished ? .fasting : .onboarding
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Routing
extension RootViewModel {
    func showPaywall() {
        router.presentPaywall()
    }
}

extension RootViewModel {
    enum RootScreen {
        case launchScreen
        case fasting
        case onboarding
        case forceUpdate(String)
    }
}
