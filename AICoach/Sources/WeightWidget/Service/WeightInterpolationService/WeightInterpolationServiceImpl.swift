//  
//  WeightInterpolationServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

class WeightInterpolationServiceImpl: WeightInterpolationService {
    func interpolate(weightHistory: [WeightHistory]) -> [WeightHistory] {
        var interpolatedHistory = [WeightHistory]()

        for i in 0..<weightHistory.count {
            interpolatedHistory.append(weightHistory[i])
            guard i < weightHistory.count - 1 else {
                break
            }
            let currentDataPoint = weightHistory[i]
            let nextDataPoint = weightHistory[i + 1]
            let timeDifference = nextDataPoint.historyDate.timeIntervalSince(currentDataPoint.historyDate) / .day

            guard timeDifference > 1 else {
                continue
            }
            let weightDifference = nextDataPoint.scaleWeightValue - currentDataPoint.scaleWeightValue
            let trueWeightDifference = nextDataPoint.trueWeightValue - currentDataPoint.trueWeightValue

            let weightIncrementPerDay = weightDifference / timeDifference
            let trueWeightIncrementPerDay = trueWeightDifference / timeDifference
            var currentDate = currentDataPoint.historyDate.add(days: 1)
            while currentDate < nextDataPoint.historyDate {
                let daysDifference = currentDate.timeIntervalSince(currentDataPoint.historyDate) / .day
                let interpolatedWeight = currentDataPoint.scaleWeightValue + weightIncrementPerDay * daysDifference
                let interpolatedTrueWeight = currentDataPoint.trueWeightValue + trueWeightIncrementPerDay * daysDifference
                let interpolatedDataPoint = WeightHistory(scaleWeightValue: interpolatedWeight,
                                                          trueWeightValue: interpolatedTrueWeight,
                                                          weightUnits: currentDataPoint.weightUnits,
                                                          historyDate: currentDate)
                interpolatedHistory.append(interpolatedDataPoint)
                currentDate = currentDate.add(days: 1)
            }
        }
        return interpolatedHistory
    }
}
