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
        router.presentStartFastingDialog(initialDate: fastingInterval.startDate) { [weak self] date in
            self?.setCurrentDate(date)
            self?.updateFastingInterval()
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
        updateFastingInterval()
    }

    private func startFasting() {
        router.presentStartFastingDialog(initialDate: fastingInterval.startDate) { [weak self] date in
            self?.setCurrentDate(date)
            self?.updateFastingInterval()
            self?.fastingService.startFasting()
        }
    }

    private func configureFastingStatus() {
        updateFastingInterval()
        updateFastingStatus()

        fastingStatusUpdateTimer
            .sink(with: self) { this, _ in
                this.updateFastingStatus()
            }
            .store(in: &cancellables)
    }

    private func updateFastingInterval() {
        fastingInterval = fastingParametersService.fastingInterval
    }

    private func updateFastingStatus() {
        fastingStatus = fastingService.status()
    }

    private func setCurrentDate(_ date: Date) {
        fastingParametersService.set(currentDate: date)
    }
}
