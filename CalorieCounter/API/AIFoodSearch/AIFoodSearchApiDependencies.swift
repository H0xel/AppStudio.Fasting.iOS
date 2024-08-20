//  
//  AIFoodSearchApiDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.08.2024.
//

import Dependencies

extension DependencyValues {
    var aiFoodSearchApi: AIFoodSearchApi {
        self[AIFoodSearchApiKey.self]
    }
}

private enum AIFoodSearchApiKey: DependencyKey {
    static var liveValue: AIFoodSearchApi = AIFoodSearchApiImpl()
}
