//  
//  FoodSearchCacheService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.01.2024.
//

protocol FoodSearchCacheService {
    func cachedFood(of barcode: String) async throws -> MealItem?
    func cache(meal: MealItem, for barcode: String) async throws
    func clearCache(for barcode: String) async throws
    func cachedIngredient(of barcode: String) async throws -> MealItem?
    func cache(ingredient: MealItem, for barcode: String) async throws
    func clearIngredientCache(for barcode: String) async throws
}
