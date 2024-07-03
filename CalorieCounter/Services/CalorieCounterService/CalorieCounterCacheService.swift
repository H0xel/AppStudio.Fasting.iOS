//  
//  CalorieCounterCacheService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 23.01.2024.
//

protocol CalorieCounterCacheService {
    func cached(request: String) async throws -> [MealItem]?
    func set(meals: [MealItem], for request: String) async throws
    func cachedIngredients(request: String) async throws -> [MealItem]?
    func set(ingredients: [MealItem], for request: String) async throws
}
