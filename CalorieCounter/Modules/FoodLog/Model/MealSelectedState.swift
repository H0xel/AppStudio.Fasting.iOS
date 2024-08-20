//
//  MealSelectedState.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 30.01.2024.
//

import Foundation

enum MealSelectedState: Equatable {
    case notSelected
    case delete
    case ingredient(IngredientStruct)
    case ingredientWeight(IngredientStruct)
    case mealWeight
    case addIngredients

    var ingredient: IngredientStruct? {
        switch self {
        case .notSelected, .delete, .mealWeight, .addIngredients:
            nil
        case .ingredient(let ingredient), .ingredientWeight(let ingredient):
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

    var isAddingIngredient: Bool {
        switch self {
        case .notSelected, .mealWeight, .delete, .ingredient, .ingredientWeight:
            return false
        case .addIngredients:
            return true
        }
    }
}
