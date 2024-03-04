//
//  MealServiceDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.12.2023.
//

import Dependencies

extension DependencyValues {
    var mealService: MealService {
        self[MealServiceKey.self]
    }
}

private enum MealServiceKey: DependencyKey {
    static var liveValue: MealService = MealServiceImpl()
    static var testValue: MealService = MealServiceImpl()
    static var previewValue: MealService = MealServicePreview()
}
