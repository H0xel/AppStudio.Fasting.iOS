//  
//  AIFoodSearchApiImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.08.2024.
//

class AIFoodSearchApiImpl: AIFoodSearchApi {
    private let provider = TelecomApiProvider<AIFoodSearchTarget>()

    func search(foodDescription: String) async throws -> [AIFoodSearchResult] {
        try await provider.request(.guess(foodDescription: foodDescription))
    }

    func nutrients(query: String) async throws -> [NutritionFood] {
        try await provider.request(.nutrients(query: query))
    }
}
