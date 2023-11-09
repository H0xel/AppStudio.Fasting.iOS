//  
//  FastingServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Dependencies
import AppStudioFoundation
import Combine

class FastingServiceImpl: FastingService {

    @Dependency(\.fastingParametersService) private var fastingParametersService

    var isFastingRunning: Bool {
        fastingParametersService.isFastingProcess
    }

    var statusPublisher: AnyPublisher<FastingStatus, Never> {
        fastingParametersService.fastingIntervalPublisher
            .map(with: self) { this, interval in
                interval.status(isFastingProcessRunning: this.isFastingRunning)
            }
            .eraseToAnyPublisher()
    }

    func startFasting(from date: Date) {     
        fastingParametersService.set(currentDate: date)
        fastingParametersService.startFastingProcess()
    }

    func endFasting() {
        fastingParametersService.endFastingProcess()
        fastingParametersService.clearCurrentDate()
    }
}
