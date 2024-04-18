//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import Foundation
import Dependencies

extension DependencyValues {
    var weightProgressChartService: WeightProgressChartService {
        self[WeightProgressChartServiceKey.self]
    }
}

private enum WeightProgressChartServiceKey: DependencyKey {
    static let liveValue = WeightProgressChartServiceImpl()
}
