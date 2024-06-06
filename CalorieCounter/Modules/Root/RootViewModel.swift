//
//  RootViewModel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies
import RxSwift
import NewAppStudioSubscriptions

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.firstLaunchService) private var firstLaunchService
    @Dependency(\.quickActionTypeServiceService) private var quickActionTypeServiceService
    @Dependency(\.trackerService) private var trackerService

    @Published var rootScreen: RootScreen = .launchScreen
    @Published var inAppPurchaseIsLoading = false

    var router: RootRouter!

    private let disposeBag = DisposeBag()

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
        subscribeToActionTypeEvent()
    }

    func initialize() {
        initializeForceUpdateIfNeeded()
    }

    func requestIdfa() {
        Task {
            await idfaRequestService.requestIDFATracking()
        }
    }

    func openAppStore(_ applink: String) {
        router.presentAppStore(applink)
    }

    var onboardingScreen: some View {
        router.onboardingScreen { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.cloudStorage.onboardingIsFinished = true
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.rootScreen = .calorieCounter
                }
            }
        }
    }

    var calorieCounterScreen: some View {
        router.tabBarScreen
    }

    func handle(status: inAppPurchaseStatus) {
        if status.isLoading {
            inAppPurchaseIsLoading = true
            return
        }
        inAppPurchaseIsLoading = false
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
            .delay(.seconds(3))
            .drive(with: self) { this, args in
                if args.shouldShowForceUpdate {
                    this.rootScreen = .forceUpdate(args.appLink)
                } else {
                    this.rootScreen = this.cloudStorage.onboardingIsFinished ? .calorieCounter : .onboarding
                }
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToActionTypeEvent() {
        $rootScreen
            .filter { $0 != .launchScreen }
            .flatMap(with: self) { this, _ in  this.quickActionTypeServiceService.quickActiveType }
            .sink(with: self) { this, type in
                if let type {
                    switch type {
                    case .review:
                        this.router.presentSupport()
                        this.quickActionTypeServiceService.resetType()
                        this.trackQuickActionReviewTapped()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: Routing
extension RootViewModel {
    func showPaywall() {
        router.presentPaywall()
    }
}

extension RootViewModel {
    enum RootScreen: Equatable {
        case launchScreen
        case calorieCounter
        case onboarding
        case forceUpdate(String)
    }
}

// MARK: Analytic
private extension RootViewModel {
    func trackQuickActionReviewTapped() {
        trackerService.track(.tapNeedAssistance)
    }
}
