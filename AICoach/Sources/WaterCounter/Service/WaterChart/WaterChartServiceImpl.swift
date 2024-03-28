//  
//  WaterChartServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.03.2024.
//

import Foundation
import Dependencies
import AppStudioModels

class WaterChartServiceImpl: WaterChartService {

    @Dependency(\.waterService) private var waterService

    func waterChartItems(for days: [Date]) async throws -> [HealthProgressBarChartItem] {
        let settings = try await waterService.settings()
        let units = settings.units

        var result: [HealthProgressBarChartItem] = []

        for day in days {
            async let water = waterService.water(for: day)
            async let goal = waterService.dailyGoal(for: day)

            let item = try await HealthProgressBarChartItem(
                value: units.valueToGlobal(value: water),
                lineValue: units.valueToGlobal(value: goal.quantity),
                color: .studioSky,
                label: day.currentLocaleFormatted(with: "eee")
            )
            result.append(item)
            await Task.yield()
        }
        return result
    }
}
