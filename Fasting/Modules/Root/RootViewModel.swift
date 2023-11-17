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

enum Step {
    case fasting
    case onboarding
}

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer

    @Published var currentTab: AppTab = .fasting
    @Published var step: Step

    var router: RootRouter!
    @Dependency(\.appCustomization) private var appCustomization

    private let disposeBag = DisposeBag()

    init(input: RootInput, output: @escaping RootOutputBlock) {
        step = input.step
        super.init(output: output)
        initialize()
    }

    func initialize() {
        initializeForceUpdateIfNeeded()
    }

    func requestIdfa() {
        idfaRequestService.requestIDFATracking()
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
                    self?.step = .fasting
                }
            }
        })
        .view
    }

    var profileScreen: some View {
        router.profileScreen
    }

    var paywallScreen: some View {
        NavigationView {
            PaywallRoute(navigator: router.navigator, input: .fromSettings) { [weak self] _ in }.view
        }
    }

    private func initializeForceUpdateIfNeeded() {
        appCustomization.forceUpdateAppVersion
            .flatMap(with: self) { this, version -> Observable<(shouldShowForceUpdate: Bool, appLink: String)> in
                this.appCustomization.appStoreLink.map {
                    (shouldShowForceUpdate: !Bundle.lessOrEqualToCurrentVersion(version), appLink: $0)
                }
            }
            .asDriver()
            .drive(with: self) { this, args in
                if args.shouldShowForceUpdate {
                    this.presentForceUpdateScreen(args.appLink)
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

    private func presentForceUpdateScreen(_ appLink: String) {
        let banner = ForceUpdateBanner { [weak self] in
            self?.router.presentAppStore(appLink)
        }
        router.present(banner: banner)
    }
}
