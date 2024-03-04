//  
//  CalorieCounterDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Dependencies

extension DependencyValues {
    var calorieCounterService: CalorieCounterService {
        self[CalorieCounterServiceKey.self]
    }
    var calorieCounterCacheService: CalorieCounterCacheService {
        self[CalorieCounterCacheServiceKey.self]
    }
}

private enum CalorieCounterServiceKey: DependencyKey {
    static let liveValue: CalorieCounterService = CalorieCounterServiceImpl()
}

private enum CalorieCounterCacheServiceKey: DependencyKey {
    static let liveValue: CalorieCounterCacheService = CalorieCounterCacheServiceImpl()
    static let testValue: CalorieCounterCacheService = CalorieCounterCacheServiceImpl()
}
