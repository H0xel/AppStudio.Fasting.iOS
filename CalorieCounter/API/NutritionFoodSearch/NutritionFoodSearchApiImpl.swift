//  
//  NutritionFoodSearchApiImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

class NutritionFoodSearchApiImpl: NutritionFoodSearchApi {
    private let provider = TelecomApiProvider<NutritionFoodSearchTarget>()

    func search(query: String) async throws -> [NutritionFood] {
        try await provider.request(.searchText(query: query))
    }

    func search(brandFoodId: String) async throws -> NutritionFood {
        try await provider.request(.searchBrand(brandFoodId: brandFoodId))
    }

    func search(code: Int64) async throws -> NutritionFood {
        try await provider.request(.searchBarcode(upc: code))
    }
}
