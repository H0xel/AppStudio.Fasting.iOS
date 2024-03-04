//
//  Meal.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

struct ApiMeal: Codable {
    let name: String
    let ingredients: [ApiIngredient]

    enum CodingKeys: String, CodingKey {
        case name = "n"
        case ingredients = "ings"
    }
}
