//  
//  WeightInterpolationDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

import Dependencies

public extension DependencyValues {
    var weightInterpolationService: WeightInterpolationService {
        self[WeightInterpolationServiceKey.self]
    }
}

private enum WeightInterpolationServiceKey: DependencyKey {
    static var liveValue: WeightInterpolationService = WeightInterpolationServiceImpl()
}
