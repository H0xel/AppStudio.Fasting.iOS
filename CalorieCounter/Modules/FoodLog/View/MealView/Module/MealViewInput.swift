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
    let tappedIngredient: Ingredient?
    let tappedWeightIngredient: Ingredient?
    let voting: MealVoting?
}
