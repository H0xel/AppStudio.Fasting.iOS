//  
//  WeightChartServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

import Foundation
import WeightWidget
import Dependencies
import AppStudioModels

struct ChartWeight {
    let date: Date
    let weight: WeightHistory
}

class WeightChartServiceImpl: WeightChartService {

    @Dependency(\.weightService) private var weightService
    @Dependency(\.weightInterpolationService) private var weightInterpolationService

    func lastDaysItems(daysCount: Int) async throws -> [LineChartItem] {

        var dates = Array((0 ..< daysCount).map { Date.now.adding(.day, value: -$0).startOfTheDay }.reversed())
        guard let startDate = dates.first, let endDate = dates.last else {
            return []
        }
        var result: [Date: WeightHistory] = [:]
        let firstHistory = try await weightService.history(byDate: startDate)

        let weightHistory: [WeightHistory] = try await weightService.history(
            from: startDate.add(days: 1),
            until: endDate
        )

        var interpolatedHistory = Array(weightInterpolationService.interpolate(
            weightHistory: ([firstHistory] + weightHistory).compactMap { $0 }
        ).suffix(daysCount))

        if let last = interpolatedHistory.last {
            interpolatedHistory.append(last.updated(historyDate: .now.endOfDay))
            dates.append(.now.endOfDay)
        }

        if let first = interpolatedHistory.first {
            let date = Date().add(days: -(daysCount - 1)).startOfTheDay.adding(.hour, value: -5)
            interpolatedHistory.insert(first.updated(historyDate: date), at: 0)
            dates.insert(date, at: 0)
        }

        for history in interpolatedHistory {
            result[history.historyDate] = history
        }

        let trueWeightItem = LineChartItem.trueWeight(
            values: dates.map {
                .init(
                    value: value(currentDate: $0,
                                 currentDateHistory: result[$0],
                                 firstHistory: firstHistory,
                                 interpolatedHistory: Array(interpolatedHistory),
                                 needScaleWeight: false),
                    label: $0
                )
            }, color: .studioBlue
        )
        let scaleWeightItem = LineChartItem.scaleWeight(
            values: dates.map {
                .init(
                    value: value(currentDate: $0,
                                 currentDateHistory: result[$0],
                                 firstHistory: firstHistory,
                                 interpolatedHistory: Array(interpolatedHistory),
                                 needScaleWeight: true),
                    label: $0
                )
            }, color: .studioGreyStrokeFill
        )
        if weightHistory.isEmpty, firstHistory?.historyDate != startDate {
            return [trueWeightItem.invisible, scaleWeightItem.invisible]
        }
        return [scaleWeightItem, trueWeightItem]
    }

    private func value(currentDate: Date,
                       currentDateHistory: WeightHistory?,
                       firstHistory: WeightHistory?,
                       interpolatedHistory: [WeightHistory],
                       needScaleWeight: Bool) -> Double {
        if let currentDateHistory {
            return needScaleWeight ? currentDateHistory.scaleWeightValue : currentDateHistory.trueWeightValue
        }
        guard let first = interpolatedHistory.first,
              let last = interpolatedHistory.last else {
            return 0
        }
        if currentDate < first.historyDate {
            if let firstHistory {
                return needScaleWeight ? firstHistory.scaleWeightValue : firstHistory.trueWeightValue
            }
            return needScaleWeight ? first.scaleWeightValue : first.trueWeightValue
        }
        return needScaleWeight ? last.scaleWeightValue : last.trueWeightValue
    }
}
