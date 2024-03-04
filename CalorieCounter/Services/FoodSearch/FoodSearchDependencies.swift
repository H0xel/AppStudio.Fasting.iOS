//  
//  FoodSearchDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

import Dependencies

extension DependencyValues {
    var foodSearchService: FoodSearchService {
        self[FoodSearchServiceKey.self]
    }

    var foodSearchCacheService: FoodSearchCacheService {
        self[FoodSearchCacheServiceKey.self]
    }
}

private enum FoodSearchServiceKey: DependencyKey {
    static let liveValue: FoodSearchService = FoodSearchServiceImpl()
    static let testValue: FoodSearchService = FoodSearchServiceImpl()
}

private enum FoodSearchCacheServiceKey: DependencyKey {
    static let liveValue: FoodSearchCacheService = FoodSearchCacheServiceImpl()
    static let testValue: FoodSearchCacheService = FoodSearchCacheServiceImpl()
}
