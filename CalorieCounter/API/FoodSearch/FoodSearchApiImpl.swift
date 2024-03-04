//  
//  FoodSearchApiImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

class FoodSearchApiImpl: FoodSearchApi {
    private let provider = FoodSearchProvider<FoodSearchTarget>()

    func search(_ request: FoodSearchRequest) async throws -> FoodSearchResponse {
        try await provider.request(.search(request))
    }
}
