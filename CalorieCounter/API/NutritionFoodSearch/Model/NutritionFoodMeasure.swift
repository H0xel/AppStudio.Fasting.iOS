//
//  NutritionFoodMeasure.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Foundation

struct NutritionFoodMeasure: Codable {
    let servingWeight: Double?
    let measure: String
    let quantity: Double?
}

extension  NutritionFoodMeasure {
    var asServing: MealServing {
        .init(weight: servingWeight, measure: measure, quantity: quantity ?? servingWeight ?? 1)
    }
}
extension Array where Element == NutritionFoodMeasure {
    var asServings: [MealServing] {
        self.map { $0.asServing }
    }
}
