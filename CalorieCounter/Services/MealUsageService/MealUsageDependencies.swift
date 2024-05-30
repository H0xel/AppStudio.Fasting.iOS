//  
//  MealUsageDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies

extension DependencyValues {
    var mealUsageService: MealUsageService {
        self[MealUsageServiceKey.self]
    }
}

private enum MealUsageServiceKey: DependencyKey {
    static var liveValue: MealUsageService = MealUsageServiceImpl()
}
