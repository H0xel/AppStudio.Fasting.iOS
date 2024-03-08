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
import HealthProgress
import Combine

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
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.fastingParametersService) private var fastingParametersService

    @Published var currentTab: AppTab = .fasting {
        willSet {
            trackTabSwitched(currentTab: newValue.rawValue, previousTab: currentTab.rawValue)
        }
    }
    @Published var rootScreen: RootScreen = .launchScreen
    @Published var hasSubscription = false
    @Published var isProcessingSubcription = false

    @Published var discountPaywallInfo: DiscountPaywallInfo?

    var router: RootRouter!
    private let disposeBag = DisposeBag()
    private let progressInputSubject = CurrentValueSubject<FastingHealthProgressInput, Never>(.empty)
    private let coachNextMessageSubject = CurrentValueSubject<String, Never>("")

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
        initializePaywallTab()
        subscribeToActionTypeEvent()
        subscribeForAvailableDiscountPaywall()
        observeCurrentTab()
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
        router.fastingScreen { [weak self] output in
            switch output {
            case .pinTapped:
                self?.currentTab = .paywall
            }
        }
    }

    lazy var coachScreen: some View = {
        router.coachScreen(nextMessagePublisher: coachNextMessageSubject.eraseToAnyPublisher())
    }()

    var healthProgressScreen: some View {
        router.healthProgressScreen(inputPublisher: progressInputSubject.eraseToAnyPublisher()) { [weak self] output in
            switch output {
            case .novaQuestion(let question):
                self?.currentTab = .coach
                self?.coachNextMessageSubject.send(question)
            }
        }
    }

    @ViewBuilder
    func discountPaywall(input: DiscountPaywallInput) -> some View {
        DiscountPaywallRoute(navigator: router.navigator, input: input) { [weak self] output in
            switch output {
            case .close, .subscribe:
                break
            case .switchProgress(let isProcessing):
                self?.isProcessingSubcription = isProcessing
            }
        }.view
    }

    lazy var onboardingScreen: some View = {
        router.onboardingScreen { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.storageService.onboardingIsFinished = true
                self?.fastingParametersInitializer.initialize()
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.rootScreen = .fasting
                }
            }
        }
    }()

    var profileScreen: some View {
        router.profileScreen
    }

    lazy var paywallScreen: some View = {
        router.paywallScreen { [weak self] isProcessing in
            self?.isProcessingSubcription = isProcessing
        }
    }()

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
        Observable.combineLatest(
            subscriptionService.hasSubscriptionObservable.distinctUntilChanged(),
            appCustomization.discountPaywallExperiment.distinctUntilChanged()
        )
        .asDriver()
        .drive(with: self) { this, args in
            let (hasSubscription, discountPaywallInfo) = args
            this.changeCurrentTabOnLaunch(hasSubsctiption: hasSubscription)
            this.hasSubscription = hasSubscription
            this.discountPaywallTimerService.registerPaywall(info: discountPaywallInfo)
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

    private func observeCurrentTab() {
        $currentTab
            .filter { $0 == .healthProgress }
            .sink { [weak self] _ in
                self?.updateHealthProgressInput()
            }
            .store(in: &cancellables)
    }

    private func updateHealthProgressInput() {
        Task {
            let input = try await fastingHealthProgressInput()
            progressInputSubject.send(input)
        }
    }

    private func fastingHealthProgressInput() async throws -> FastingHealthProgressInput {
        let dates = (0...6).map { Date().adding(.day, value: -$0) }
        let historyWithDates = try await fastingHistoryService.history(for: dates)
        var orderedHistory: [FastingIntervalHistory] = []

        for date in dates {
            if let history = historyWithDates[date] {
                orderedHistory.append(history)
            } else {
                let parameters = try await fastingParametersService.parameters(for: date)
                orderedHistory.append(.empty(statedDate: date, plan: parameters.plan))
            }
        }

        let chartItems = orderedHistory.map {
            HealthProgressBarChartItem(value: $0.timeFasted,
                                       lineValue: Double($0.plan.duration / .hour),
                                       color: $0.stage.backgroundColor,
                                       label: $0.startedDate.currentLocaleFormatted(with: "EEE"))
        }
        return .init(bodyMassIndex: bodyMassIndex, fastingChartItems: chartItems.reversed())
    }

    private var bodyMassIndex: Double {
        guard let data = onboardingService.data else {
            return 0
        }
        let heightMetters = data.height.centimeters / 100
        let bodyMassIndex = data.weight.normalizeValue / (heightMetters * heightMetters)
        return bodyMassIndex
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
