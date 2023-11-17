//  
//  FastingParametersService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Combine

protocol FastingParametersService {
    var fastingIntervalPublisher: AnyPublisher<FastingInterval, Never> { get }
    var isFastingProcess: Bool { get }
    func set(currentDate date: Date) async throws
    func clearCurrentDate() async throws
    func set(fastingInterval interval: FastingInterval) async throws
    func startFastingProcess() async throws
    func endFastingProcess() async throws
}
