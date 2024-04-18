//  
//  WaterChartDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 25.03.2024.
//

import Dependencies

public extension DependencyValues {
    var waterChartService: WaterChartService {
        self[WaterChartServiceKey.self]
    }
}

private enum WaterChartServiceKey: DependencyKey {
    static var liveValue: WaterChartService = WaterChartServiceImpl()
}
