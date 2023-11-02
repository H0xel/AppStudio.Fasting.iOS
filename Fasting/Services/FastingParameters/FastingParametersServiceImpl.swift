//  
//  FastingParametersServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

class FastingParametersServiceImpl: FastingParametersService {
    var fastingInterval: FastingInterval = {
        .init(start: Date().addingTimeInterval(.second * 10), plan: .regular, currentDate: nil)
    }()

    func set(currentDate date: Date) {
        fastingInterval.currentDate = date
    }

    func clearCurrentDate() {
        fastingInterval.currentDate = nil
    }

    func set(fastingInterval interval: FastingInterval) {
        fastingInterval = interval
    }
}
