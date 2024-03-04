//
//  MealSelectedState.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 30.01.2024.
//

import Foundation

enum MealSelectedState {
    case notSelected
    case delete(Meal)
    case ingredient(Meal, Ingredient)
    case ingredientWeight(Meal, Ingredient)
    case mealWeight(Meal)
    case addIngredients(Meal)

    var meal: Meal? {
        switch self {
        case .notSelected:
            nil
        case .delete(let meal), .addIngredients(let meal), .ingredientWeight(let meal, _),
                .mealWeight(let meal), .ingredient(let meal, _):
            meal
        }
    }

    var ingredient: Ingredient? {
        switch self {
        case .notSelected, .delete, .mealWeight, .addIngredients:
            nil
        case .ingredient(_, let ingredient), .ingredientWeight(_, let ingredient):
            ingredient
        }
    }

    var isMealSelected: Bool {
        switch self {
        case .notSelected:
            false
        case .delete, .addIngredients:
            true
        case .ingredientWeight, .mealWeight, .ingredient:
            false
        }
    }

    var isNotSelected: Bool {
        switch self {
        case .notSelected:
            true
        case .delete, .addIngredients:
            false
        case .ingredientWeight, .mealWeight, .ingredient:
            false
        }
    }

    var isWeightEditing: Bool {
        switch self {
        case .notSelected, .delete, .addIngredients, .ingredient:
            false
        case .ingredientWeight, .mealWeight:
            true
        }
    }
}
