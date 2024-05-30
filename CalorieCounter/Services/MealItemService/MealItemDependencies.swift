//  
//  MealItemDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Dependencies

extension DependencyValues {
    var mealItemService: MealItemService {
        self[MealItemServiceKey.self]
    }
}

private enum MealItemServiceKey: DependencyKey {
    static var liveValue: MealItemService = MealItemServiceImpl()
}
