//  
//  AIFoodSearchApi.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.08.2024.
//

protocol AIFoodSearchApi {
    func search(foodDescription: String) async throws -> [AIFoodSearchResult]
    func nutrients(query: String) async throws -> [NutritionFood]
}
