//
//  FoodLogItem.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 21.12.2023.
//

import Foundation

enum FoodLogItem: Hashable {
    case meal(Meal)
    case placeholder(MealPlaceholder)
    case notFoundBarcode(MealPlaceholder)

    var placeholderId: String? {
        switch self {
        case .meal:
            return nil
        case .placeholder(let mealPlaceholder), .notFoundBarcode(let mealPlaceholder):
            return mealPlaceholder.id
        }
    }
    
    var id: String {
        switch self {
        case .meal(let meal):
            return meal.id
        case .placeholder(let mealPlaceholder), .notFoundBarcode(let mealPlaceholder):
            return mealPlaceholder.id
        }
    }

    var meal: Meal? {
        switch self {
        case .meal(let meal):
            return meal
        case .placeholder, .notFoundBarcode:
            return nil
        }
    }
}
