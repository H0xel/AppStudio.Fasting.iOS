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

class FastingViewModel: BaseViewModel<FastingOutput> {

    @Dependency(\.fastingService) private var fastingService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.fastingHistoryService) private var fastingHistoryService

    var router: FastingRouter!
    @Published var fastingStatus: FastingStatus = .unknown
    @Published var fastingInterval: FastingInterval = .empty
    private let fastingStatusUpdateTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
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

    var fastingStages: [FastingStage] {
        return fastingInterval.plan != .beginner
        ? FastingStage.allCases
        : FastingStage.allCases.filter { $0 != .autophagy }
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
                self?.fastingService.startFasting(from: date)
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

    private func endFasting() {
        if fastingStatus.isFinished {
            fastingService.endFasting()
            presentSuccesScreen()
            return
        }
        presentEndFastingEarlyScreen()
    }

    private func startFasting() {
        let minAllowedDate = min(fastingInterval.startDate, .now)

        router.presentStartFastingDialog(isActiveState: isFastingActive,
                                         initialDate: minAllowedDate,
                                         minDate: .now.adding(.day, value: -2),
                                         maxDate: .now) { [weak self] date in
            self?.fastingService.startFasting(from: date)
        }
    }

    private func configureFastingStatus() {
        fastingStatusUpdateTimer
            .flatMap(with: self) { this, _ in this.fastingService.statusPublisher }
            .assign(to: &$fastingStatus)
    }

    private func configureFastingInterval() {
        fastingParametersService.fastingIntervalPublisher
            .assign(to: &$fastingInterval)
    }

    private func setCurrentDate(_ date: Date) {
        Task { [weak self] in
            try await self?.fastingParametersService.set(currentDate: date)
        }
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
                try await self?.fastingHistoryService.saveHistory(interval: fastingInterval,
                                                                  startedAt: startDate,
                                                                  finishedAt: endDate)
                self?.fastingService.endFasting()
            }
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
