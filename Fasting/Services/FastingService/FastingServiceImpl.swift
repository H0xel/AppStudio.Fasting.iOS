//  
//  FastingServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Dependencies
import AppStudioFoundation

class FastingServiceImpl: FastingService {

    @Dependency(\.fastingParametersService) private var fastingParametersService

    var isFastingRunning = false

    func status() -> FastingStatus {
        isFastingRunning ? activeState : inActiveState
    }

    func startFasting() {
        let startDate = fastingParametersService.fastingInterval.startDate
        let interval = Date.now.timeIntervalSince(startDate)
        if interval < 0 {
            fastingParametersService.set(currentDate: startDate.add(days: -1))
        }
        isFastingRunning = true
    }

    func endFasting() {
        isFastingRunning = false
        fastingParametersService.clearCurrentDate()
        let currentInterval = fastingParametersService.fastingInterval
        var nextStartDate = currentInterval.startDate
        if nextStartDate.isSameDay(with: .now) {
            nextStartDate = nextStartDate.add(days: 1)
        }
        fastingParametersService.set(fastingInterval: .init(start: nextStartDate,
                                                            plan: currentInterval.plan,
                                                            currentDate: nil))
    }

    private var activeState: FastingStatus {
        .active(.init(interval: timeToFast, stage: fastingStage, isFinished: false))
    }

    private var fastingStage: FastingStage {
        switch timeToFast {
        case 0 ... .hour * 2:
            return .sugarRises
        case .hour * 2 ... .hour * 8:
            return .sugarDrop
        case .hour * 8 ... .hour * 10:
            return .sugarNormal
        case .hour * 10 ... .hour * 14:
            return .burning
        case .hour * 14 ... .hour * 16:
            return .ketosis
        default:
            return .autophagy
        }
    }

    private var inActiveState: FastingStatus {
        nextFastTime > 0 ? .inActive(.left(nextFastTime)) : .inActive(.expired)
    }

    private var timeToFast: TimeInterval {
        let startDate = fastingParametersService.fastingInterval.startDate
        return Date.now.timeIntervalSince(startDate)
    }

    private var nextFastTime: TimeInterval {
        let startDate = fastingParametersService.fastingInterval.startDate
        return startDate.timeIntervalSince(.now)
    }
}
