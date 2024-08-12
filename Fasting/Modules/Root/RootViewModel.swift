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
import HealthProgress
import Combine
import HealthOverview
import FastingWidget
import WeightWidget
import AppStudioModels
import AppStudioServices
import NewAppStudioSubscriptions

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.fastingParametersInitializer) private var fastingParametersInitializer
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.firstLaunchService) private var firstLaunchService
    @Dependency(\.quickActionTypeServiceService) private var quickActionTypeServiceService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.weightService) private var weightService
    @Dependency(\.localNotificationService) private var localNotificationService
    @Dependency(\.onboardingApi) private var onboardingApi
    @Dependency(\.intercomService) private var intercomService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.rootInitializationService) private var rootInitializationService

    @Published var currentTab: AppTab = .daily {
        willSet {
            trackTabSwitched(currentTab: newValue.rawValue, previousTab: currentTab.rawValue)
        }
    }
    @Published var rootScreen: RootScreen = .launchScreen
    @Published var hasSubscription = false
    @Published var isProcessingSubcription = false

    @Published var discountPaywallInfo: DiscountPaywallInfo?

    let router: RootRouter
    private let disposeBag = DisposeBag()
    private let coachNextMessageSubject = CurrentValueSubject<String, Never>("")
    private let progressInputSubject = CurrentValueSubject<FastingHealthProgressInput, Never>(.empty)
    private let fastingWidgetStateSubject = CurrentValueSubject<FastingWidgetState, Never>(.mockInActive)
    private var fastingViewModel: FastingViewModel!

    init(router: RootRouter, input: RootInput, output: @escaping RootOutputBlock) {
        self.router = router
        super.init(output: output)
        initializeHasSubscription()
        initilizeFastingViewModel()
        initialize()
        initializeDiscountExp()
        subscribeToActionTypeEvent()
        subscribeForAvailableDiscountPaywall()
        observeCurrentTab()
        updateHealthProgressInput()
        registerDiscountNotification()
    }

    func initialize() {
        newSubscriptionService.hasSubscription
            .dropFirst()
            .removeDuplicates()
            .assign(to: &$hasSubscription)

        rootInitializationService
            .rootSetup
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, setup in
                this.hasSubscription = setup.hasSubscription
                if setup.hasSubscription {
                    this.deleteDiscountNotification()
                }
                this.rootScreen = setup.rootScreen
            }
            .store(in: &cancellables)
    }

    func requestIdfa() {
        Task {
            await idfaRequestService.requestIDFATracking()
        }
    }

    func openAppStore(_ applink: String) {
        router.presentAppStore(applink)
    }

    lazy var exploreScreen: some View = {
        router.exploreScreen { [weak self] output in
            switch output {
            case .nova(let question):
                self?.currentTab = .coach
                self?.coachNextMessageSubject.send(question)
            }
        }
    }()

    lazy var healthOverviewScreen: some View = {
        router.healthOverviewScreen(input: .init(
            fastingWidget: fastingWidget,
            weightUnits: onboardingService.data?.weight.units ?? .kg,
            monetizationIsAvailable: $hasSubscription.map { !$0 }.eraseToAnyPublisher()
        )) { [weak self] output in
            self?.handle(healthOverviewOutput: output)
        }
    }()

    lazy var fastingScreen: some View = {
        router.fastingScreen
    }()

    lazy var coachScreen: some View = {
        router.coachScreen(isMonetizationExpAvailable: $hasSubscription.map { !$0 }.eraseToAnyPublisher(),
                           nextMessagePublisher: coachNextMessageSubject.eraseToAnyPublisher()) { [weak self] output in
            switch output {
            case .presentMultiplePaywall:
                self?.router.presentMultipleProductPaywall(context: .nova)
            case .focusChanged: break
            }
        }
    }()

    lazy var healthProgressScreen: some View = {
        router.healthProgressScreen(
            isMonetizationExpAvailablePublisher: $hasSubscription.map { !$0 }.eraseToAnyPublisher(),
            inputPublisher: progressInputSubject.eraseToAnyPublisher()
        ) { [weak self] output in self?.handle(healthProgressScreenOutput: output) }
    }()

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
                self?.cloudStorage.onboardingIsFinished = true
                self?.fastingParametersInitializer.initialize()
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.rootScreen = .fasting
                }
            }
        }
    }()

    lazy var paywallScreen: some View = {
        router.paywallScreen { [weak self] isProcessing in
            self?.isProcessingSubcription = isProcessing
        }
    }()

    func handle(deepLink: DeepLink?) {
        switch deepLink {
        case .discount:
            if let discountPaywallInfo {
                router.presentDiscountPaywall(tab: currentTab, info: discountPaywallInfo, context: .discountPush)
            }
        case .intercom:
            Task {
                await router.popToRoot()
                intercomService.hideIntercom()
                intercomService.presentIntercom()
                    .sink { _ in }
                    .store(in: &cancellables)
            }
        case nil: break
        }
    }

    func handle(status: inAppPurchaseStatus) {
        if status.isLoading {
            isProcessingSubcription = true
            return
        }
        isProcessingSubcription = false
    }

    private func handle(healthProgressScreenOutput: HealthProgressOutput) {
        switch healthProgressScreenOutput {
        case .novaQuestion(let question):
            currentTab = .coach
            coachNextMessageSubject.send(question)
        case .delete(let historyId):
            let fastingHistoryService = fastingHistoryService
            Task { [weak self] in
                try await fastingHistoryService.delete(byId: historyId)
                self?.updateHealthProgressInput()
            }
        case .edit(let historyId):
            updateFasting(fastingId: historyId)
        case .addHistory:
            logFast(for: .now)
        case .updateInput:
            updateHealthProgressInput()
        case .presentMultipleProductPaywall:
            router.presentMultipleProductPaywall(context: .progress)
        }
    }

    private func handle(healthOverviewOutput output: HealthOverviewOutput) {
        switch output {
        case .profileTapped:
            router.presentProfile()
        case .showPaywall:
            router.presentMultipleProductPaywall(context: .daily)
        case .showDiscountPaywall:
            if let discountPaywallInfo {
                router.presentDiscountPaywall(tab: currentTab, info: discountPaywallInfo, context: .daily)
            }
        case .showPopUpPaywall:
            guard !isProcessingSubcription else { return }
            if let discountPaywallInfo {
                router.presentDiscountPaywall(tab: currentTab, info: discountPaywallInfo, context: .popup)
                return
            }
            router.presentMultipleProductPaywall(context: .popup)
        }
    }

    private var fastingWidget: FastingWidget {
        FastingWidget(
            input: .init(fastingStatePublisher: fastingWidgetStateSubject.eraseToAnyPublisher())
        ) { [weak self] output in
            self?.handle(fastingWidgetOutput: output)
        }
    }

    private func handle(fastingWidgetOutput output: FastingWidgetOutput) {
        switch output {
        case .logFasting(let date):
            logFast(for: date)
        case .updateFasting(let fastingId):
            updateFasting(fastingId: fastingId)
        }
    }

    private func logFast(for date: Date) {
        trackerService.track(.tapLogPreviousFast(date: date.description))
        Task { [weak self] in
            guard let self else { return }
            let parameters = try await self.fastingParametersService.parameters(for: date)
            let interval = parameters.asInterval
            let startDateComponents = DateComponents(calendar: .current,
                                                     timeZone: .current,
                                                     year: date.year,
                                                     month: date.month,
                                                     day: date.day,
                                                     hour: interval.startDate.hour,
                                                     minute: interval.startDate.minute,
                                                     second: interval.startDate.second)
            guard let startDate = startDateComponents.date else {
                return
            }
            let endDate = startDate.addingTimeInterval(parameters.plan.duration)
            let input = SuccessInput(plan: parameters.plan,
                                     startDate: startDate,
                                     endDate: endDate,
                                     isEmpty: true)
            let fasting = FastingIntervalHistory(currentDate: .now,
                                                 startedDate: startDate,
                                                 finishedDate: endDate,
                                                 plan: parameters.plan)
            presentSuccessScreen(input: input, fasting: fasting, isNew: true)
        }
    }

    private func updateFasting(fastingId: String) {
        Task { [weak self] in
            guard let self,
                  let fasting = try await self.fastingHistoryService.history(byId: fastingId) else {
                return
            }
            self.trackerService.track(.tapUpdatePreviousFast(date: fasting.startedDate.description))
            let input = SuccessInput(plan: fasting.plan,
                                     startDate: fasting.startedDate,
                                     endDate: fasting.finishedDate,
                                     isEmpty: false)
            self.presentSuccessScreen(input: input, fasting: fasting, isNew: false)
        }
    }

    private func presentSuccessScreen(
        on tab: AppTab? = nil,
        input: SuccessInput,
        fasting: FastingIntervalHistory,
        isNew: Bool
    ) {
        let tab = tab ?? currentTab
        router.presentSuccess(on: tab, input: input) { [weak self] output in
            switch output {
            case let .submit(startDate, endDate):
                self?.saveHistory(fasting: fasting, startDate: startDate, endDate: endDate, isNew: isNew, tab: tab)
            }
        }
    }

    private func saveHistory(fasting: FastingIntervalHistory,
                             startDate: Date,
                             endDate: Date,
                             isNew: Bool,
                             tab: AppTab) {
        Task {
            let history = FastingIntervalHistory(id: fasting.id,
                                                 currentDate: fasting.currentDate,
                                                 startedDate: startDate,
                                                 finishedDate: endDate,
                                                 plan: fasting.plan)
            try await fastingHistoryService.save(history: history)
            if isNew {
                trackFastingLogged(fasting: history)
            } else {
                trackFastingUpdated(newFasting: history, oldFasting: fasting)
            }
            if tab == .healthProgress {
                updateHealthProgressInput()
            }
        }
    }

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func initializeDiscountExp() {
        appCustomization.discountPaywallExperiment
            .distinctUntilChanged()
            .asDriver()
            .drive(with: self) { this, discountPaywallInfo in
                if let discountPaywallInfo {
                    this.discountPaywallTimerService.registerPaywall(info: discountPaywallInfo)
                }
            }
            .disposed(by: disposeBag)
    }

    private func initializeHasSubscription() {
        newSubscriptionService.hasSubscription.assign(to: &$hasSubscription)
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
            .sink { [weak self] tab in
                if tab == .healthProgress {
                    self?.updateHealthProgressInput()
                }
                if tab == .fasting {
                    self?.fastingViewModel.router.isWidgetPresented = false
                }
                if tab == .daily {
                    self?.fastingViewModel.router.isWidgetPresented = true
                }
                self?.updateHealthProgressInput()
            }
            .store(in: &cancellables)
    }

    private func initilizeFastingViewModel() {
        fastingViewModel = .init(input: .init(
            isMonetizationAvailable: $hasSubscription.eraseToAnyPublisher())
        ) { [weak self] output in
            switch output {
            case .pinTapped:
                if let discountPaywallInfo = self?.discountPaywallInfo {
                    self?.router.presentDiscountPaywall(tab: .fasting, info: discountPaywallInfo, context: .discountPin)
                }
            case .updateWidget(let state):
                self?.fastingWidgetStateSubject.send(state)
            case .showPaywallFromArticle:
                self?.router.presentMultipleProductPaywall(context: .fastingStages)
            }
        }
        let route = FastingRoute(viewModel: fastingViewModel)
        router.fastingNavigator.initialize(with: route)
        fastingViewModel.router = .init(navigator: router.fastingNavigator,
                                        fastingWidgetNavigator: router.healthOverviewNavigator)
    }

    private func updateHealthProgressInput() {
        Task {
            let input = try await fastingHealthProgressInput()
            progressInputSubject.send(input)
            userPropertyService.set(userProperties: ["bmi": input.bodyMassIndex])
        }
    }

    private func fastingHealthProgressInput() async throws -> FastingHealthProgressInput {
        let calendar = Calendar.current
        var components = DateComponents()

        components.year = 2023
        components.month = 11
        components.day = 20

        let releaseApplicationDate = calendar.date(from: components) ?? .now
        let daysAfterReleaseDate = calendar.dateComponents([.day], from: releaseApplicationDate, to: .now).day ?? 0

        let fastingHistoryDates = (0...daysAfterReleaseDate).map { Date().adding(.day, value: -$0) }
        let fastingHistoryWithDates = try await fastingHistoryService.history(for: fastingHistoryDates)
        var fastingHistoryAfterReleaseDate: [FastingIntervalHistory] = []

        for date in fastingHistoryDates {
            if let history = fastingHistoryWithDates[date] {
                fastingHistoryAfterReleaseDate.append(history)
            } else {
                let parameters = try await fastingParametersService.parameters(for: date)
                fastingHistoryAfterReleaseDate.append(.empty(statedDate: date, plan: parameters.plan))
            }
        }

        let lastSevenDays = Array(fastingHistoryAfterReleaseDate.prefix(7))

        let chartItems = lastSevenDays.map {
            HealthProgressBarChartItem(value: $0.timeFasted,
                                       lineValue: Double($0.plan.duration / .hour),
                                       color: $0.stage.backgroundColor,
                                       label: $0.startedDate.currentLocaleFormatted(with: "EEE"))
        }

        let chartHistoryItems = fastingHistoryAfterReleaseDate.map {
            return FastingHistoryChartItem(value: $0.timeFasted,
                                           lineValue: Double($0.plan.duration / .hour),
                                           date: $0.startedDate,
                                           stage: .init(fastingStage: $0.stage))
        }
        let allHistory = try await fastingHistoryService.history()
        let fastingHistoryRecords = allHistory.reduce(into: [FastingHistoryRecord]()) { records, history in
            records.append(
                FastingHistoryRecord(id: history.id,
                                     startDate: history.startedDate,
                                     endDate: history.finishedDate )
            )
        }
        let fastingHistoryData = FastingHistoryData(records: fastingHistoryRecords)

        return try await .init(bodyMassIndex: bodyMassIndex(),
                               weightUnits: onboardingService.data?.weight.units ?? .kg,
                               fastingChartItems: chartItems.reversed(),
                               fastingHistoryChartItems: chartHistoryItems.reversed(),
                               fastingHistoryData: fastingHistoryData)
    }

    func bodyMassIndex() async throws -> Double {
        guard let data = onboardingService.data else {
            return 0
        }
        let currentWeight = try await weightService.history(byDate: .now)?.trueWeight.normalizeValue ??
        data.weight.normalizeValue
        let heightMetters = data.height.normalizeValue / 100
        let bodyMassIndex = currentWeight / (heightMetters * heightMetters)
        return bodyMassIndex
    }

    private func registerDiscountNotification() {
        $rootScreen
            .sink(with: self) { this, screen in
                if screen == .fasting {
                    guard let notificationStartedDate = this.discountPaywallTimerService.delayedTimerDate,
                          !this.hasSubscription else { return }
                    Task {
                        try await this.localNotificationService.register(
                            DiscountLocalNotification(),
                            at: .init(year: notificationStartedDate.year,
                                      month: notificationStartedDate.month,
                                      day: notificationStartedDate.day,
                                      hour: notificationStartedDate.hour,
                                      minute: notificationStartedDate.minute,
                                      second: notificationStartedDate.second)
                        )
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func deleteDiscountNotification() {
        localNotificationService.clearPendingNotification(id: DiscountLocalNotification().id)
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

    func trackFastingLogged(fasting: FastingIntervalHistory) {
        trackerService.track(.fastingLogged(timeFasted: "\(fasting.timeFasted)",
                                            startTime: fasting.startedDate.description,
                                            endTime: fasting.finishedDate.description,
                                            schedule: fasting.plan.description))
    }

    func trackFastingUpdated(newFasting: FastingIntervalHistory, oldFasting: FastingIntervalHistory) {
        trackerService.track(.fastingUpdated(
            newTimeFasted: "\(newFasting.timeFasted)",
            newStartTime: newFasting.startedDate.description,
            newEndTime: newFasting.finishedDate.description,
            oldTimeFasted: "\(oldFasting.timeFasted)",
            oldStartTime: oldFasting.startedDate.description,
            oldEndTime: oldFasting.finishedDate.description,
            schedule: newFasting.plan.description)
        )
    }
}
