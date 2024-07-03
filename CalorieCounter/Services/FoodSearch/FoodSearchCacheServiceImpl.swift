//  
//  FoodSearchCacheServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 22.01.2024.
//
import Dependencies

class FoodSearchCacheServiceImpl: FoodSearchCacheService {
    @Dependency(\.codableCacheRepository) private var codableCacheRepository

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
}
