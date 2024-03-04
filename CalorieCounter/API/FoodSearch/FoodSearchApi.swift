//  
//  FoodSearchApi.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.01.2024.
//

protocol FoodSearchApi {
    func search(_ request: FoodSearchRequest) async throws -> FoodSearchResponse
}
