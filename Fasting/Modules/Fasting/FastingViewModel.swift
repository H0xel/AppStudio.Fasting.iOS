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

    var router: FastingRouter!
    @Published var fastingStatus: FastingStatus = .inActive(.expired)
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
        }
    }

    var fastingStartTime: String {
        fastingInterval.startDate.currentLocaleFormatted(with: "HHmm")
    }

    var fastingEndTime: String {
        fastingInterval.endDate.currentLocaleFormatted(with: "HHmm")
    }

    var currentStage: FastingStage? {
        switch fastingStatus {
        case .active(let fastingActiveState):
            return fastingActiveState.stage
        case .inActive:
            return nil
        }
    }

    func changeFastingTime() {
        router.presentStartFastingDialog(
            initialDate: fastingInterval.startDate,
            allowSelectFuture: !isFastingActive
        ) { [weak self] date in
            self?.setCurrentDate(date)
        }
    }

    func toggleFasting() {
        if isFastingActive {
            endFasting()
            return
        }
        startFasting()
    }

    private func endFasting() {
        fastingService.endFasting()
    }

    private func startFasting() {
        let minAllowedDate = min(fastingInterval.startDate, .now)
        router.presentStartFastingDialog(
            initialDate: minAllowedDate,
            allowSelectFuture: false
        ) { [weak self] date in
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
        fastingParametersService.set(currentDate: date)
    }
}
