//
//  ArticleNutritionProfile.swift
//
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

struct ArticleNutritionProfile: Codable, Hashable {
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbs: Double
}

extension ArticleNutritionProfile {
    static var mock: ArticleNutritionProfile {
        .init(calories: 376, proteins: 12, fats: 12, carbs: 25)
    }
}
