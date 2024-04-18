//
//  TrueWeightCalculationService.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation

protocol TrueWeightCalculationService {
    func calculate(history: WeightHistory) async throws -> Double
    func calculate(history: [WeightHistory]) -> Double?
}
