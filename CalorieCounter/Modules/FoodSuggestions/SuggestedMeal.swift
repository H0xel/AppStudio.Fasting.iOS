//
//  SuggestedMeal.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import SwiftUI

struct SuggestedMeal: Identifiable, Equatable, Hashable {
    let icon: Image
    let mealItem: MealItem

    var id: String {
        mealItem.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(mealItem)
    }
}

extension SuggestedMeal {
    static func mock(mealType: MealType) -> SuggestedMeal {
        .init(icon: mealType.image, mealItem: .mock)
    }

    static var mockLog: SuggestedMeal {
        .init(icon: .init(.logItemsSuggest), mealItem: .mock)
    }
}
