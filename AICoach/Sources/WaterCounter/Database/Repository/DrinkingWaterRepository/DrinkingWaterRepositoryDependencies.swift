//  
//  DrinkingWaterDependencies.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Dependencies

extension DependencyValues {
    var drinkingWaterRepository: DrinkingWaterRepository {
        self[DrinkingWaterRepositoryKey.self]
    }
}

private enum DrinkingWaterRepositoryKey: DependencyKey {
    static var liveValue: DrinkingWaterRepository = DrinkingWaterRepositoryImpl()
}
