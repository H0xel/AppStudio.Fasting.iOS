//  
//  FastingParametersService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

protocol FastingParametersService {
    var fastingInterval: FastingInterval { get }
    func set(currentDate date: Date)
    func clearCurrentDate()

    func set(fastingInterval interval: FastingInterval)
}
