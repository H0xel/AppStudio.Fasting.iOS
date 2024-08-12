//
//  SuggestedMeal.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import SwiftUI
enum SuggestedMealType: Equatable, Hashable {
    case favorite(MealType)
    case history
    case foodSearch

    var sortedScore: Double {
        switch self {
        case .favorite:
            1000
        case .history:
            500
        case .foodSearch:
            0
        }
    }
}

struct SuggestedMeal: Identifiable, Equatable, Hashable {
    let type: SuggestedMealType
    let mealItem: MealItem

    var id: String {
        mealItem.id
    }

    var icon: Image {
        switch type {
        case .favorite(let mealType):
            mealType.image
        case .history:
            mealItem.suggestionIcon
        case .foodSearch:
            .init(.logFoodSearch)
        }
    }

    func score(for request: String) -> Double {
        mealItem.searchScore(for: request) + type.sortedScore
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(mealItem)
    }
}

extension SuggestedMeal {
    static func mock(mealType: MealType) -> SuggestedMeal {
        .init(type: .favorite(mealType), mealItem: .mock)
    }

    static var mockLog: SuggestedMeal {
        .init(type: .history, mealItem: .mock)
    }
}

private extension MealItem {
    var suggestionIcon: Image {
        switch type {
        case .chatGPT, .quickAdd, .custom, .ingredient, .needToUpdateBrand:
                .init(.logItemsSuggest)
        case .product:
                .init(.customFoodSuggest)
        case .recipe:
                .init(.recipeSuggest)
        }
    }
}
