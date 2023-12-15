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

class FastingViewModel: BaseViewModel<FastingOutput> {

    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.fastingFinishedCyclesLimitService) private var fastingFinishedCyclesLimitService
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.requestReviewService) private var requestReviewService

    var router: FastingRouter!
    @Published var fastingStatus: FastingStatus = .unknown
    @Published var fastingInterval: FastingInterval = .empty
    @Published var fastingStages: [FastingStage] = []
    @Published var hasSubscription = false
    private let fastingStatusUpdateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let disposeBag = DisposeBag()

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
        fastingStages = updateFastingStages(fastingInterval: fastingInterval, fastingStatus: fastingStatus)
        configureFastingStatus()
        configureFastingInterval()
        observeSubscription()
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
            trackTapEndFasting()
            endFasting()
            return
        }
        startFasting()
        trackTapStartFasting()
    }

    func onChangeFastingTapped() {
        router.presentSetupFasting(plan: fastingInterval.plan)
        trackTapSchedule()
    }

    private func startFastingIfPossible(from date: Date) {
        if fastingFinishedCyclesLimitService.isLimited {
            Task {
                await presentPaywallAndStartFasting(from: date)
            }
            return
        }
        fastingService.startFasting(from: date)
        trackFastingStarted(startTime: date.description)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestReviewService.requestAppStoreReview()
        }
    }

    @MainActor
    private func presentPaywallAndStartFasting(from date: Date) async {
        router.presentPaywall { [weak self] paywallOutput in
            if paywallOutput == .subscribed {
                self?.fastingService.startFasting(from: date)
            }
            self?.router.dismiss()
        }
    }

    private func endFasting() {
        if fastingStatus.isFinished {
            trackFastingFinished()
            fastingService.endFasting()
            presentSuccesScreen()
            return
        }
        presentEndFastingEarlyScreen()
    }

    private func startFasting() {
        router.presentStartFastingDialog(isActiveState: isFastingActive,
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
        subscriptionService.hasSubscriptionObservable
            .asDriver()
            .drive(with: self) { this, hasSubscription in
                this.hasSubscription = hasSubscription
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Routing
extension FastingViewModel {

    func presentArticle(for stage: FastingStage) {
        trackerService.track(.tapFastingStages(stage: stage.rawValue, context: .mainScreen))
        router.presentArticle(for: stage)
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

    private func presentEndFastingEarlyScreen() {
        router.presentEndFastingEarly { event in
            switch event {
            case .end:
                Task { [weak self] in
                    await self?.router.dismiss()
                    self?.presentSuccesScreen()
                }
            }
        }
        trackDontGiveUpScreenShown()
    }
}

private extension FastingViewModel {
    func trackTapStartFasting() {

        if case let .inActive(stage) = fastingStatus {
            switch stage {
            case .expired:
                trackerService.track(.tapStartFasting(
                    currentTime: Date.now.description,
                    startTime: fastingInterval.startDate.description,
                    timeUntilFast: "",
                    schedule: fastingInterval.plan.description
                ))
            case let .left(interval):
                trackerService.track(.tapStartFasting(
                    currentTime: Date.now.description,
                    startTime: fastingInterval.startDate.description,
                    timeUntilFast: interval.toTime,
                    schedule: fastingInterval.plan.description
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

    func trackTapSchedule() {
        trackerService.track(.tapSchedule(currentSchedule: fastingInterval.plan.description))
    }

    func trackTapEndFasting() {
        if case let .active(stage) = fastingStatus {
            trackerService.track(.tapEndFasting(
                timeFasted: stage.interval.toTime,
                startTime: fastingInterval.startDate.description,
                currentTime: Date.now.description,
                schedule: fastingInterval.plan.description))
        }
    }

    func trackFastingFinished() {
        if case let .active(stage) = fastingStatus {
            trackerService.track(.tapEndFasting(
                timeFasted: stage.interval.toTime,
                startTime: fastingInterval.startDate.description,
                currentTime: Date.now.description,
                schedule: fastingInterval.plan.description))
        }
    }

    func trackDontGiveUpScreenShown() {
        trackerService.track(.dontGiveUpScreenShown)
    }
}
