//
//  Ingredient.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct OldIngredient: Codable, Hashable {
    let name: String
    let brandTitle: String?
    let weight: Double
    let normalizedProfile: NutritionProfile

    var nameWithBrand: String {
        if let brandTitle {
            return "\(name) by \(brandTitle)"
        }
        return name
    }
}

typealias Ingredient = MealItem

extension Ingredient {
    var nameWithBrand: String {
        if let brandTitle = subTitle {
            return "\(name) by \(brandTitle)"
        }
        return name
    }

    var nameDotBrand: String {
        if let brandTitle = subTitle {
            return "\(name.capitalized)  ·  \(brandTitle.capitalized )"
        }
        return name.capitalized
    }
}
