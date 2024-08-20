//  
//  FoodSearchCacheServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.01.2024.
//
import Dependencies

class FoodSearchCacheServiceImpl: FoodSearchCacheService {
    @Dependency(\.codableCacheRepository) private var codableCacheRepository

    func clearAllCache() async throws {
        try await codableCacheRepository.clearAll(of: .foodSearch)
        try await codableCacheRepository.clearAll(of: .foodSearchIngredient)
        try await codableCacheRepository.clearAll(of: .foodsTextSearch)
        try await codableCacheRepository.clearAll(of: .brandedFood)
        try await codableCacheRepository.clearAll(of: .aiFood)
        try await codableCacheRepository.clearAll(of: .aiNutrients)
    }

    func cachedFood(of barcode: String) async throws -> MealItem? {
        guard let cachedValue = try await codableCacheRepository.value(key: barcode,
                                                                       of: .foodSearch,
                                                                       cacheInterval: .month) else {
            return nil
        }
        return try MealItem(json: cachedValue)
    }

    func cache(meal: MealItem, for barcode: String) async throws {
        if let jsonValue = meal.json() {
            _ = try await codableCacheRepository.set(key: barcode, value: jsonValue, for: .foodSearch)
        }
    }

    func clearCache(for barcode: String) async throws {
        try await codableCacheRepository.clear(key: barcode, of: .foodSearch)
    }

    func cachedIngredient(of barcode: String) async throws -> MealItem? {
        guard let cachedValue = try await codableCacheRepository.value(key: barcode,
                                                                       of: .foodSearchIngredient,
                                                                       cacheInterval: .month) else {
            return nil
        }
        return try MealItem(json: cachedValue)
    }

    func cache(ingredient: MealItem, for barcode: String) async throws {
        if let jsonValue = ingredient.json() {
            _ = try await codableCacheRepository.set(key: barcode, value: jsonValue, for: .foodSearchIngredient)
        }
    }

    func clearIngredientCache(for barcode: String) async throws {
        try await codableCacheRepository.clear(key: barcode, of: .foodSearchIngredient)
    }

    func cachedFoods(of query: String) async throws -> [MealItem]? {
        guard let cachedValue = try await codableCacheRepository.value(key: query,
                                                                       of: .foodsTextSearch,
                                                                       cacheInterval: .month) else {
            return nil
        }
        return try [MealItem](json: cachedValue)
    }
    
    func cache(foods: [MealItem], for query: String) async throws {
        if let jsonValue = foods.json() {
            _ = try await codableCacheRepository.set(key: query, value: jsonValue, for: .foodsTextSearch)
        }
    }

    func clearFoodsCache(for query: String) async throws {
        try await codableCacheRepository.clear(key: query, of: .foodsTextSearch)
    }

    func cachedBrandFood(of brandFoodId: String) async throws -> MealItem? {
        guard let cachedValue = try await codableCacheRepository.value(key: brandFoodId,
                                                                       of: .brandedFood,
                                                                       cacheInterval: .month) else {
            return nil
        }
        return try MealItem(json: cachedValue)
    }

    func cache(brandFood: MealItem, for brandFoodId: String) async throws {
        if let jsonValue = brandFood.json() {
            _ = try await codableCacheRepository.set(key: brandFoodId, value: jsonValue, for: .brandedFood)
        }
    }

    func clearBrandFoodCache(for brandFoodId: String) async throws {
        try await codableCacheRepository.clear(key: brandFoodId, of: .brandedFood)
    }
}
