//
//  TrueWeightCalculationServiceImpl.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import Dependencies

class TrueWeightCalculationServiceImpl: TrueWeightCalculationService {

    @Dependency(\.weightHistoryRepository) private var weightHistoryRepository
    @Dependency(\.weightInterpolationService) private var weightInterpolationService

    func calculate(history: WeightHistory) async throws -> Double {
        let weightHistory = try await weightHistoryRepository.history(until: history.historyDate).reversed()
        let filteredHistory = filteredHistory(Array(weightHistory))
        let interpolatedWeight = weightInterpolationService.interpolate(weightHistory: filteredHistory)
        guard !interpolatedWeight.isEmpty else {
            return history.scaleWeightValue
        }
        guard interpolatedWeight.count > 14 else {
            return interpolatedWeight.reduce(0) { $0 + $1.scaleWeightValue } / Double(interpolatedWeight.count)
        }
        let lastIndex = interpolatedWeight.count - 1
        let weights = interpolatedWeight.enumerated().map {
            let coef = exp(-Double(lastIndex - $0.offset) / 10.0)
            return ($0.element.scaleWeightValue * coef, coef)
        }
        let weightsSun = weights.reduce(0) { $0 + $1.0 }
        let coefsSum = weights.reduce(0) { $0 + $1.1 }
        return weightsSun / coefsSum
    }

    func calculate(history: [WeightHistory]) -> Double? {
        guard !history.isEmpty else {
            return nil
        }
        guard history.count > 14 else {
            return history.reduce(0) { $0 + $1.scaleWeightValue } / Double(history.count)
        }
        let lastIndex = history.count - 1
        let weights = history.enumerated().map {
            let coef = exp(-Double(lastIndex - $0.offset) / 10.0)
            return ($0.element.scaleWeightValue * coef, coef)
        }
        let weightsSun = weights.reduce(0) {
            $0 + $1.0
        }
        let coefsSum = weights.reduce(0) {
            $0 + $1.1
        }
        return weightsSun / coefsSum
    }

    private func filteredHistory(_ weightHistory: [WeightHistory]) -> [WeightHistory] {
        var historyDict: [Date: WeightHistory] = [:]

        for history in weightHistory {
            historyDict[history.historyDate] = history
        }

        return historyDict.keys.sorted().compactMap { historyDict[$0] }
    }
}
