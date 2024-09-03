//  
//  FastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import SwiftUI
import Dependencies
import Combine
import RxSwift
import HealthOverview
import FastingWidget
import AppStudioServices

class FastingViewModel: BaseViewModel<FastingOutput> {

    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.fastingFinishedCyclesLimitService) private var fastingFinishedCyclesLimitService
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.requestReviewService) private var requestReviewService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.rateAppService) private var rateAppService
    @Dependency(\.intercomService) private var intercomService
    @Dependency(\.appCustomization) private var appCustomization

    var router: FastingRouter!
    @Published var fastingStatus: FastingStatus = .unknown
    @Published var fastingInterval: FastingInterval = .empty
    @Published var fastingStages: [FastingStage] = []
    @Published var hasSubscription = false
    @Published var discountPaywallInfo: DiscountPaywallInfo?
    @Published var monetizationIsAvailable = false
    private let fastingStatusUpdateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let disposeBag = DisposeBag()

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
        fastingStages = updateFastingStages(fastingInterval: fastingInterval, fastingStatus: fastingStatus)
        configureFastingStatus()
        configureFastingInterval()
        observeSubscription()
        subscribeToDiscountAvailable()
        input.isMonetizationAvailable
            .assign(to: &$monetizationIsAvailable)
    }

    var isFastingActive: Bool {
        switch fastingStatus {
        case .active:
            return true
        case .inActive:
            return false
        case .unknown:
            return false
        }
    }

    var fastingStartTime: String {
        fastingInterval.startDate.localeTimeString
    }

    var fastingEndTime: String {
        fastingInterval.endDate.localeTimeString
    }

    var currentStage: FastingStage? {
        switch fastingStatus {
        case .active(let fastingActiveState):
            return fastingActiveState.stage
        case .inActive:
            return nil
        case .unknown:
            return nil
        }
    }

    func changeFastingTime() {
        router.presentStartFastingDialog(
            isActiveState: isFastingActive,
            initialDate: fastingInterval.startDate,
            minDate: .now.adding(.day, value: -2),
            maxDate: .now.adding(.day, value: isFastingActive ? 0 : 1)
        ) { [weak self] date in
            self?.setCurrentDate(date)
            if date.timeIntervalSinceNow < 0 && self?.isFastingActive == false {
                self?.startFastingIfPossible(from: date)
            }
        }
        trackTapChangeFastingStartTime()
    }

    func toggleFasting() {
        if isFastingActive {
            trackTapEndFasting(context: "fasting")
            endFasting(context: "fasting")
            return
        }
        startFasting()
        trackTapStartFasting(context: "fasting")
    }

    func onChangeFastingTapped(context: SetupFastingInput.Context) {
        router.presentSetupFasting(plan: fastingInterval.plan, context: context)
        trackTapSchedule(context: context.rawValue)
    }

    func inActiveStageTapped(_ article: FastingInActiveArticle) {
        if article != .fastingPhases {
            router.presentInActiveFastingArticle(article)
            trackTapArticle(article: article.buttonTitle.lowercased())
            return
        }
        presentArticle(for: .sugarRises)
    }

    func subscribeToDiscountAvailable() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    func pinTapped() {
        output(.pinTapped)
    }

    private func startFastingIfPossible(from date: Date) {
        if monetizationIsAvailable {
            startFasting(date: date)
            return
        }

        if fastingFinishedCyclesLimitService.isLimited, !hasSubscription {
            Task {
                await presentPaywallAndStartFasting(from: date)
            }
            return
        }
        startFasting(date: date)
    }

    @MainActor
    private func presentPaywallAndStartFasting(from date: Date) async {
        router.presentPaywall { [weak self] paywallOutput in
            if case .subscribed = paywallOutput {
                self?.startFasting(date: date)
            }
            switch paywallOutput {
            case .close, .subscribed:
                self?.router.dismiss()
            default: break
            }
        }
    }

    private func startFasting( date: Date) {
        fastingService.startFasting(from: date)
        trackFastingStarted(startTime: date.description)
    }

    private func endFasting(context: String) {
        if fastingStatus.isFinished {
            trackFastingFinished(context: context)
            presentSuccesScreen()
            return
        }
        presentEndFastingEarlyScreen(context: context)
    }

    private func startFasting() {
        router.presentStartFastingDialog(isActiveState: true,
                                         initialDate: .now,
                                         minDate: .now.adding(.day, value: -2),
                                         maxDate: .now) { [weak self] date in
            self?.startFastingIfPossible(from: date)
        }
    }

    private func configureFastingStatus() {
        Publishers.Merge(fastingStatusUpdateTimer, Just(.now))
            .flatMap(with: self) { this, _ in this.fastingService.statusPublisher }
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, status in
                this.fastingStages = this.updateFastingStages(fastingInterval: this.fastingInterval,
                                                              fastingStatus: status)
                this.fastingStatus = status
                this.updateFastingWidget(status: status)
            }
            .store(in: &cancellables)
    }

    private func configureFastingInterval() {
        fastingParametersService.fastingIntervalPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$fastingInterval)
    }

    private func setCurrentDate(_ date: Date) {
        Task { [weak self] in
            try await self?.fastingParametersService.set(currentDate: date)
        }
    }

    private func updateFastingStages(fastingInterval: FastingInterval,
                                     fastingStatus: FastingStatus) -> [FastingStage] {
        guard fastingInterval.plan == .beginner else { return FastingStage.allCases }

        if case let .active(activeState) = fastingStatus {
            return activeState.interval > FastingPlan.regular.duration
            ? FastingStage.allCases
            : FastingStage.withoutAutophagy
        }

        return FastingStage.withoutAutophagy
    }

    private func observeSubscription() {
        newSubscriptionService.hasSubscription
            .assign(to: &$hasSubscription)
    }
}

// MARK: - Fasting Widget
extension FastingViewModel {
    private func updateFastingWidget(status: FastingStatus) {
        switch status {
        case .unknown:
            updateFastingWidgetWithInactiveStatus(stage: .expired)
        case .active(let stage):
            updateFastingWidgetWithActiveStatus(stage: stage)
        case .inActive(let stage):
            updateFastingWidgetWithInactiveStatus(stage: stage)
        }
    }

    private func updateFastingWidgetWithActiveStatus(stage: FastingActiveState) {
        let state = ActiveFastingWidgetState(
            startDate: fastingInterval.startDate,
            finishDate: fastingInterval.endDate,
            phases: fastingStages,
            onEndFastingTap: { [weak self] in
                self?.endFasting(context: "daily")
            },
            onSettingsTap: { [weak self] in
                self?.onChangeFastingTapped(context: .daily)
            },
            onCircleTap: { [weak self] in
                if let currentStage = self?.currentStage {
                    self?.presentArticle(for: currentStage)
                }
            }
        )
        output(.updateWidget(.active(state)))
    }

    private func updateFastingWidgetWithInactiveStatus(stage: InActiveFastingStage) {
        switch stage {
        case .left(let timeInterval):
            let state = InActiveFastingWidgetState(
                title: "HalthOverviewScreen.nextFastIn".localized(),
                subtitle: timeInterval.toTime,
                onButtonTap: { [weak self] in
                    self?.trackTapStartFasting(context: "daily")
                    self?.startFasting()
                },
                onSettingsTap: { [weak self] in
                    self?.onChangeFastingTapped(context: .daily)
                }
            )
            output(.updateWidget(.inactive(state)))
        case .expired:
            let state = InActiveFastingWidgetState(
                title: "",
                subtitle: "HalthOverviewScreen.readyToFast".localized(),
                onButtonTap: { [weak self] in
                    self?.trackTapStartFasting(context: "daily")
                    self?.startFasting()
                },
                onSettingsTap: { [weak self] in
                    self?.onChangeFastingTapped(context: .daily)
                })
            output(.updateWidget(.inactive(state)))
        }
    }
}

// MARK: Routing
extension FastingViewModel {

    func presentArticle(for stage: FastingStage) {
        trackerService.track(.tapFastingStages(stage: stage.rawValue, context: .mainScreen))
        router.presentArticle(isMonetizationExpAvailable: monetizationIsAvailable, for: stage) { [weak self] output in
            switch output {
            case .presentPaywallFromArticle:
                self?.output(.showPaywallFromArticle)
            }
        }
    }

    private func presentSuccesScreen() {
        router.presentSuccess(plan: fastingInterval.plan,
                              startDate: fastingInterval.startDate,
                              endDate: .now) { [weak self] event in
            self?.handle(successOutput: event)
        }
    }

    private func handle(successOutput event: SuccessOutput) {
        switch event {
        case let .submit(startDate, endDate):
            let fastingInterval = fastingInterval
            Task { [weak self] in
                try await self?.finishFastingSuccessfully(fastingInterval: fastingInterval,
                                                          startDate: startDate,
                                                          endDate: endDate)

                try await self?.presentRateAppIfNeeded()
            }
        }
    }

    private func finishFastingSuccessfully(
        fastingInterval: FastingInterval,
        startDate: Date,
        endDate: Date
    ) async throws {
        try await fastingHistoryService.saveHistory(interval: fastingInterval,
                                                    startedAt: startDate,
                                                    finishedAt: endDate)
        fastingService.endFasting()
        let interval = endDate.timeIntervalSince(startDate)
        if interval >= 5 * .hour {
            fastingFinishedCyclesLimitService.increaseLimit(by: 1)
        }
    }

    private func presentRateAppIfNeeded() async throws {
        if try await appCustomization.canShowRateUsDialog(), try await rateAppService.canShowRateUsDialog() {
            try await Task.sleep(seconds: 1)
            presentRateUsDialog()
            rateAppService.rateUsDialogShown()
            trackerService.track(.rateUsDialogShown)
            return
        }
        if rateAppService.canShowAppStoreReviewDialog {
            await MainActor.run {
                requestReviewService.requestAppStoreReview()
            }
        }
    }

    private func presentRateUsDialog() {
        router.presentRateUsDialog { [weak self] output in
            guard let self else { return }
            switch output {
            case .presentSupport:
                self.presentIntercome()
            case .rating(let rating):
                self.trackerService.track(.rateUsDialogAnswered(rate: rating))
                self.rateAppService.userRatedUs()
            case .presentWriteReview:
                break
            }
        }
    }

    private func presentIntercome() {
        intercomService.presentIntercom()
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
    }

    private func presentEndFastingEarlyScreen(context: String) {
        router.presentEndFastingEarly { event in
            switch event {
            case .end:
                Task { [weak self] in
                    await self?.router.dismiss()
                    self?.trackFastingFinished(context: context)
                    self?.presentSuccesScreen()
                }
            }
        }
        trackDontGiveUpScreenShown()
    }
}

private extension FastingViewModel {
    func trackTapStartFasting(context: String) {
        if case let .inActive(stage) = fastingStatus {
            switch stage {
            case .expired:
                trackerService.track(.tapStartFasting(
                    currentTime: Date.now.description,
                    startTime: fastingInterval.startDate.description,
                    timeUntilFast: "",
                    schedule: fastingInterval.plan.description,
                    context: context
                ))
            case let .left(interval):
                trackerService.track(.tapStartFasting(
                    currentTime: Date.now.description,
                    startTime: fastingInterval.startDate.description,
                    timeUntilFast: interval.toTime,
                    schedule: fastingInterval.plan.description,
                    context: context
                ))
            }
        }
    }

    func trackFastingStarted(startTime: String) {
        trackerService.track(.fastingStarted(
            currentTime: Date.now.description,
            startTime: startTime,
            schedule: fastingInterval.plan.description)
        )
    }

    func trackTapChangeFastingStartTime() {
        trackerService.track(.tapChangeFastingStartTime(context: .fastingScreen))
    }

    func trackTapSchedule(context: String) {
        trackerService.track(.tapSchedule(currentSchedule: fastingInterval.plan.description, context: context))
    }

    func trackTapEndFasting(context: String) {
        if case let .active(stage) = fastingStatus {
            trackerService.track(.tapEndFasting(
                timeFasted: stage.interval.toTime,
                startTime: fastingInterval.startDate.description,
                currentTime: Date.now.description,
                schedule: fastingInterval.plan.description,
                context: context))
        }
    }

    func trackFastingFinished(context: String) {
        if case let .active(stage) = fastingStatus {
            trackerService.track(.tapEndFasting(
                timeFasted: stage.interval.toTime,
                startTime: fastingInterval.startDate.description,
                currentTime: Date.now.description,
                schedule: fastingInterval.plan.description,
                context: context))
        }
    }

    func trackDontGiveUpScreenShown() {
        trackerService.track(.dontGiveUpScreenShown)
    }
}

private extension FastingViewModel {
    func trackTapArticle(article: String) {
        trackerService.track(.tapFastingArticles(article: article))
    }
}
