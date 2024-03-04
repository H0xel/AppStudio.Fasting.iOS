//  
//  FoodSearchApiDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Dependencies

extension DependencyValues {
    var foodSearchApi: FoodSearchApi {
        self[FoodSearchApiKey.self]
    }
}

private enum FoodSearchApiKey: DependencyKey {
    static let liveValue: FoodSearchApi = FoodSearchApiImpl()
    static let testValue: FoodSearchApi = FoodSearchApiImpl()
}
