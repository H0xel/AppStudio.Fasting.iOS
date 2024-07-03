//  
//  CalorieCounterServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Dependencies
import Foundation

class CalorieCounterServiceImpl: CalorieCounterService {
    @Dependency(\.calorieCounterApi) private var calorieCounterApi
    @Dependency(\.calorieCounterCacheService) private var calorieCounterCacheService

    func food(request: String) async throws -> [MealItem] {
        if let cachedMeals: [MealItem] = try await calorieCounterCacheService.cached(request: request) {
            return cachedMeals
        }

        let meals = try await calorieCounterApi.food(request: request).meals.map { $0.asMeal }
        try await calorieCounterCacheService.set(meals: meals, for: request)

        return meals
    }

    func ingredients(request: String) async throws -> [MealItem] {
        if let cachedIngredients: [MealItem] = try await calorieCounterCacheService.cachedIngredients(request: request) {
            return cachedIngredients
        }

        let ingredients = try await calorieCounterApi.ingredients(request: request).ingredients.map { $0.asIngridient }
        try await calorieCounterCacheService.set(ingredients: ingredients, for: request)

        return ingredients
    }
}

private extension ApiIngredient {
    var asIngridient: MealItem {
        .createIngredient(
            name: name,
            brand: nil,
            weight: weight,
            nutritionProfile: .init(calories: calories,
                                    proteins: proteins,
                                    fats: fats,
                                    carbohydrates: carbohydrates)
        )

    }
}

private extension ApiMeal {
    var asMeal: MealItem {
        MealItem(
            id: UUID().uuidString,
            type: .chatGPT,
            name: ingredients.count == 1 ? "" : name,
            ingredients: ingredients.map { $0.asIngridient },
            servingMultiplier: 1.0, 
            servings: .defaultServings
        )
    }
}
