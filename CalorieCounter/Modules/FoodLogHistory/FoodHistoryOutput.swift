//
//  FoodHistoryOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.06.2024.
//

import Foundation

enum FoodHistoryOutput {
    case insert(Meal)
    case save(meals: [Meal], placeholderId: String)
    case remove(MealItem)
    case appendPlaceholder(MealPlaceholder)
    case dismiss
    case notFoundBarcode(String)
    case hasSubscription(Bool)
    case logType(type: LogType, isFocused: Bool)
    case onFocus
    case present(MealItem)
}
