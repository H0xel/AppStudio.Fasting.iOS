//
//  Ingredient.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

struct ApiIngredient: Codable {
    let name: String
    let weight: Double
    let calories: Double
    let proteins: Double
    let fats: Double
    let carbohydrates: Double

    enum CodingKeys: String, CodingKey {
        case name = "i"
        case weight = "g"
        case calories = "kcal"
        case proteins = "p"
        case fats = "f"
        case carbohydrates = "c"
    }
}
