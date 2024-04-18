//  
//  WeightChartDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

import Dependencies

extension DependencyValues {
    var weightChartService: WeightChartService {
        self[WeightChartServiceKey.self]
    }
}

private enum WeightChartServiceKey: DependencyKey {
    static var liveValue: WeightChartService = WeightChartServiceImpl()
}
