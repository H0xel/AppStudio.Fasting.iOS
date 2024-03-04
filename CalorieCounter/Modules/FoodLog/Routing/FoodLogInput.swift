//  
//  FoodLogInput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

enum FoodLogContext {
    case input
    case barcode
    case view

    var isKeyboardFocused: Bool {
        self == .input
    }
}

struct FoodLogInput {
    let mealType: MealType
    let dayDate: Date
    let context: FoodLogContext
    let initialMeal: [Meal]
    let hasSubscription: Bool
    let mealsCountInDay: Int
}
