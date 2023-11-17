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
        Task { [unowned self] in
            try await fastingParametersService.set(currentDate: date)
            try await fastingParametersService.startFastingProcess()
        }
    }

    func endFasting() {
        Task { [unowned self] in
            try await fastingParametersService.endFastingProcess()
            try await fastingParametersService.clearCurrentDate()
        }
    }
}
