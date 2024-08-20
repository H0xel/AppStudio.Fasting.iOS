//
//  MealViewInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.06.2024.
//

import Foundation

struct MealViewInput {
    let meal: MealItem
    let ingredientPlaceholders: [MealPlaceholder]
    let isTapped: Bool
    let isWeightTapped: Bool
    let tappedIngredient: IngredientStruct?
    let tappedWeightIngredient: IngredientStruct?
    let voting: MealVoting?
}
