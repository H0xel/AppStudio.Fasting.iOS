//
//  MealEditType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import Foundation

enum MealEditType {
    case deleteMeal
    case deleteIngredient
    case quickAddMeal

    var deleteButtonTitle: String {
        switch self {
        case .deleteMeal:
            NSLocalizedString("MealDeleteBanner.deleteMeal", comment: "")
        case .deleteIngredient:
            NSLocalizedString("MealDeleteBanner.deleteIngredient", comment: "")
        case .quickAddMeal:
            NSLocalizedString("MealDeleteBanner.deleteMeal", comment: "")
        }
    }

    var editButtonTitle: String? {
        switch self {
        case .deleteMeal:
            nil
        case .deleteIngredient:
            nil
        case .quickAddMeal:
            NSLocalizedString("MealDeleteBanner.editMeal", comment: "")
        }
    }
}
