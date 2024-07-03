//  
//  NutritionFoodSearchApiImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

class NutritionFoodSearchApiImpl: NutritionFoodSearchApi {
    private let provider = TelecomApiProvider<NutritionFoodSearchTarget>()

    func search(code: Int64) async throws -> NutritionFood {
        try await provider.request(.search(upc: code))
    }
}
