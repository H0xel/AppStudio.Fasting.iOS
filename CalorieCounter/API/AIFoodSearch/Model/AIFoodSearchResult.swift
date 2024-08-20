//
//  AIFoodSearchResult.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.08.2024.
//

import Foundation

struct AIFoodSearchResult: Codable {
    let foodName: String
    let ingredients: [NutritionFood]
}

extension AIFoodSearchResult {
    var asIngredientMealItems: [IngredientStruct] {
        ingredients.compactMap { $0.asIngredientMealItem }.map { IngredientStruct(mealItem: $0) }
    }

    var asMeal: MealItem? {
        guard !ingredients.isEmpty else {
            return nil
        }
        return MealItem(
            id: UUID().uuidString,
            type: .chatGPT,
            name: foodName,
            subTitle: nil,
            brandFoodId: nil,
            notes: nil,
            ingredients: asIngredientMealItems,
            normalizedProfile: .empty,
            additionInfo: nil,
            totalWeight: nil,
            servingMultiplier: 1.0,
            serving: .serving,
            servings: [.serving],
            dateUpdated: .now
        )
    }
}

extension Array where Element == AIFoodSearchResult {
    var asMealItems: [MealItem] {
        self.compactMap { $0.asMeal }
    }
}
