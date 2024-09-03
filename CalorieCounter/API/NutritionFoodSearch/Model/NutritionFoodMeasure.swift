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
        if servingWeight != nil {
            if measure == MealServing.ounces.measure {
                return MealServing.ounces
            }
            if measure == MealServing.pounds.measure {
                return MealServing.pounds
            }
        }

        return .init(weight: servingWeight, measure: measure, quantity: quantity ?? servingWeight ?? 1)
    }
}

extension Array where Element == NutritionFoodMeasure {
    var asServings: [MealServing] {
        var uniqueMeasures = Set<String>()
        return self.map { $0.asServing }
            .filter {
                if uniqueMeasures.contains($0.measure) {
                    return false
                }
                uniqueMeasures.insert($0.measure)
                return true
            }
    }
}
