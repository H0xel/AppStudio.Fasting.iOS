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

class FastingViewModel: BaseViewModel<FastingOutput> {

    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService
    @Dependency(\.fastingFinishedCyclesLimitService) private var fastingFinishedCyclesLimitService

    var router: FastingRouter!
    @Published var fastingStatus: FastingStatus = .unknown
    @Published var fastingInterval: FastingInterval = .empty
    @Published var fastingStages: [FastingStage] = []
    private let fastingStatusUpdateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
        fastingStages = updateFastingStages(fastingInterval: fastingInterval, fastingStatus: fastingStatus)
        configureFastingStatus()
        configureFastingInterval()
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
    }

    func toggleFasting() {
        if isFastingActive {
            endFasting()
            return
        }
        startFasting()
    }

    func onChangeFastingTapped() {
        router.presentSetupFasting(plan: fastingInterval.plan)
    }

    private func startFastingIfPossible(from date: Date) {
        if fastingFinishedCyclesLimitService.isLimited {
            Task {
                await presentPaywallAndStartFasting(from: date)
            }
            return
        }
        fastingService.startFasting(from: date)
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
}

// MARK: Routing
extension FastingViewModel {

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
    }
}
