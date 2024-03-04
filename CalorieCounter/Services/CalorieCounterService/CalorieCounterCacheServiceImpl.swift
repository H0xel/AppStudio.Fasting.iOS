//
//  CalorieCounterCacheServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 23.01.2024.
//
import Dependencies

class CalorieCounterCacheServiceImpl: CalorieCounterCacheService {

    @Dependency(\.codableCacheRepository) private var codableCacheRepository

    func cached(request: String) async throws -> [MealItem]? {
        guard let json = try await codableCacheRepository.value(key: request,
                                                                of: .calorieCounter,
                                                                cacheInterval: .month),
              let meals = try? [MealItem].init(json: json) else {
            return nil
        }
        return meals
    }

    func set(meals: [MealItem], for request: String) async throws {
        _ = try await codableCacheRepository.set(key: request,
                                                 value: meals.json() ?? "",
                                                 for: .calorieCounter)
    }

    func cached(request: String) async throws -> [Ingredient]? {
        guard let json = try await codableCacheRepository.value(key: request,
                                                                of: .ingredients,
                                                                cacheInterval: .month),
              let ingredients = try? [Ingredient].init(json: json) else {
            return nil
        }
        return ingredients
    }

    func set(ingredients: [Ingredient], for request: String) async throws {
        _ = try await codableCacheRepository.set(key: request,
                                                 value: ingredients.json() ?? "",
                                                 for: .ingredients)
    }
}
