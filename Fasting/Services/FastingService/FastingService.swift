//
//  FastingService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Combine

protocol FastingService {
    var statusPublisher: AnyPublisher<FastingStatus, Never> { get }
    func startFasting(from date: Date)
    func endFasting()
}
