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

    @Dependency(\.aiFoodSearchApi) private var aiFoodSearchApi

    private var isEnglishLanguage: Bool {
        "en" == Locale.current.identifier.split(separator: "_").first ?? "en"
    }

    func food(request: String) async throws -> [MealItem] {
        guard isEnglishLanguage else {
            return try await oldFood(request: request)
        }

        if let cachedMeals: [MealItem] = try await calorieCounterCacheService.cached(request: request),
           !cachedMeals.isEmpty {
            return cachedMeals
        }

        let meals = try await aiFoodSearchApi.search(foodDescription: request).asMealItems
        try await calorieCounterCacheService.set(meals: meals, for: request)
        return meals
    }

    func ingredients(request: String) async throws -> [IngredientStruct] {
        guard isEnglishLanguage else {
            return try await oldIingredients(request: request)
        }

        if let cachedIngredients: [MealItem] = try await calorieCounterCacheService.cachedIngredients(request: request),
           !cachedIngredients.isEmpty {
            return cachedIngredients.map { IngredientStruct(mealItem: $0)}
        }

        let ingredients = try await aiFoodSearchApi.nutrients(query: request).compactMap { $0.asIngredientMealItem }

        try await calorieCounterCacheService.set(ingredients: ingredients, for: request)

        return ingredients.map { IngredientStruct(mealItem: $0)}
    }


    func oldFood(request: String) async throws -> [MealItem] {
        if let cachedMeals: [MealItem] = try await calorieCounterCacheService.cached(request: request),
           !cachedMeals.isEmpty {
            return cachedMeals
        }
        let meals = try await calorieCounterApi.food(request: request).meals.map { $0.asMeal }
        try await calorieCounterCacheService.set(meals: meals, for: request)
        return meals
    }

    func oldIingredients(request: String) async throws -> [IngredientStruct] {
        if let cachedIngredients: [MealItem] = try await calorieCounterCacheService.cachedIngredients(request: request),
           !cachedIngredients.isEmpty {
            return cachedIngredients.map { IngredientStruct(mealItem: $0)}
        }
        let ingredients = try await calorieCounterApi.ingredients(request: request)
            .ingredients.map { $0.asIngridient.mealItem }
        try await calorieCounterCacheService.set(ingredients: ingredients, for: request)

        return ingredients.map { IngredientStruct(mealItem: $0) }
    }
}

private extension ApiIngredient {
    var asIngridient: IngredientStruct {
        IngredientStruct(
            name: name,
            brandTitle: nil,
            weight: weight,
            normalizedProfile: .init(calories: calories,
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
            serving: ingredients.count == 1 ? .defaultServing : .serving,
            servings: ingredients.count == 1 ? .defaultServings : [.serving]
        )
    }
}
