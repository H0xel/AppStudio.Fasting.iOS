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
import AppStudioSubscriptions

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.firstLaunchService) private var firstLaunchService
    @Dependency(\.quickActionTypeServiceService) private var quickActionTypeServiceService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    @Published var currentTab: AppTab = .fasting {
        willSet {
            trackTabSwitched(currentTab: newValue.rawValue, previousTab: currentTab.rawValue)
        }
    }
    @Published var rootScreen: RootScreen = .launchScreen
    @Published var hasSubscription = false

    @Published var discountPaywallInfo: DiscountPaywallInfo?


    var router: RootRouter!

    private let disposeBag = DisposeBag()

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
        initializePaywallTab()
        subscribeToActionTypeEvent()
        subscribeForAvailableDiscountPaywall()
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

    @ViewBuilder
    func discountPaywall(input: DiscountPaywallInput) -> some View {
        DiscountPaywallRoute(navigator: router.navigator, input: input) { _ in }.view
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

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func initializePaywallTab() {
        subscriptionService.hasSubscriptionObservable
            .distinctUntilChanged()
            .flatMap(with: self, { this, hasSubscription -> Observable<(hasSubscription: Bool, discountPaywallInfo: DiscountPaywallInfo)> in
                this.appCustomization.discountPaywallExperiment
                    .map { (hasSubscription, $0) }
            })
            .asDriver()
            .drive(with: self) { this, args in
                this.changeCurrentTabOnLaunch(hasSubsctiption: args.hasSubscription)
                this.hasSubscription = args.hasSubscription
                this.discountPaywallTimerService.registerPaywall(info: args.discountPaywallInfo)
            }
            .disposed(by: disposeBag)
    }

    private func changeCurrentTabOnLaunch(hasSubsctiption: Bool) {
        if hasSubsctiption {
            currentTab = .fasting
            return
        }
        if !firstLaunchService.isFirstTimeLaunch {
            currentTab = .paywall
        }
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
        case fasting
        case onboarding
        case forceUpdate(String)
    }
}

private extension RootViewModel {
    func trackTabSwitched(currentTab: String, previousTab: String) {
        guard rootScreen == .fasting, currentTab != previousTab else { return }
        trackerService.track(.tabSwitched(currentTab: currentTab, previousTab: previousTab))
    }

    func trackQuickActionReviewTapped() {
        trackerService.track(.tapNeedAssistance)
    }
}
