//  
//  MealItemRepositoryDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies

extension DependencyValues {
    var mealItemRepository: MealItemRepository {
        self[MealItemRepositoryKey.self]
    }
}

private enum MealItemRepositoryKey: DependencyKey {
    static var liveValue: MealItemRepository = MealItemRepositoryImpl()
}
