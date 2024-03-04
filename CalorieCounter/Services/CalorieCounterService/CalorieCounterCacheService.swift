//  
//  CalorieCounterCacheService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 23.01.2024.
//

protocol CalorieCounterCacheService {
    func cached(request: String) async throws -> [MealItem]?
    func set(meals: [MealItem], for request: String) async throws
    func cached(request: String) async throws -> [Ingredient]?
    func set(ingredients: [Ingredient], for request: String) async throws
}
