//
//  MealViewOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.06.2024.
//

import Foundation

enum MealViewOutput {
    case mealUpdated(meal: Meal)
    case mealDeleted(meal: Meal)
    case banner(isPresented: Bool)
    case selected(String)
    case editQuickAdd(Meal)
    case hasSubscription(Bool)
}
