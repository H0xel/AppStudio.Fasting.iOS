//
//  IngredientsResponse.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 29.01.2024.
//

import Foundation

struct IngredientsResponse: Codable {
    let ingredients: [ApiIngredient]

    enum CodingKeys: String, CodingKey {
        case ingredients = "ings"
    }
}
