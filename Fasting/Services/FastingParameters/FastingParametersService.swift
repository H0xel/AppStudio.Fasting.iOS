//  
//  FastingParametersService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Combine

protocol FastingParametersService {
    var fastingIntervalPublisher: AnyPublisher <FastingInterval, Never> { get }
    var isFastingProcess: Bool { get }
    func set(currentDate date: Date)
    func clearCurrentDate()
    func set(fastingInterval interval: FastingInterval)
    func startFastingProcess()
    func endFastingProcess()
}
