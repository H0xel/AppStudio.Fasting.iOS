//  
//  MealUsageRepositoryDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies

extension DependencyValues {
    var mealUsageRepository: MealUsageRepository {
        self[MealUsageRepositoryKey.self]
    }
}

private enum MealUsageRepositoryKey: DependencyKey {
    static var liveValue: MealUsageRepository = MealUsageRepositoryImpl()
}
