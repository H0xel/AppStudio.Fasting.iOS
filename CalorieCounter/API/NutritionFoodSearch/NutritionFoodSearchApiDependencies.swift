//  
//  NutritionFoodSearchApiDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Dependencies

extension DependencyValues {
    var nutritionFoodSearchApi: NutritionFoodSearchApi {
        self[NutritionFoodSearchApiKey.self]
    }
}

private enum NutritionFoodSearchApiKey: DependencyKey {
    static var liveValue: NutritionFoodSearchApi = NutritionFoodSearchApiImpl()
}
