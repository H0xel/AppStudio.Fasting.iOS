//
//  MealItem.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct MealItem: Codable, Hashable {
    let name: String
    let subTitle: String?
    let ingredients: [Ingredient]
}

extension MealItem {
    var weight: Double {
        ingredients.reduce(0) { $0 + $1.weight }
    }

    var nameFromIngredients: String {
        var result = ""
        for (index, ingredient) in ingredients.enumerated() {
            let separator = index == ingredients.count - 1 ? " & " : ", "
            if !result.isEmpty {
                result += separator
            }
            result += ingredient.name
        }
        return result
    }

    var brandSubtitle: String? {
        if let subTitle {
            return subTitle
        }

        if ingredients.count == 1, let ingredientBrandTitle = ingredients.first?.brandTitle {
            return ingredientBrandTitle
        }

        return nil
    }

    var mealName: String {
        if name.isEmpty {
            return nameFromIngredients
        }

        if ingredients.count == 1, let ingredient = ingredients.first, !ingredient.name.isEmpty {
            if let brandTitle = ingredient.brandTitle {
                return "\(ingredient.name) by \(brandTitle)"
            }
            return ingredient.name
        }
        return name
    }

    var nutritionProfile: NutritionProfile {
        ingredients.reduce(.empty) { $0 ++ $1.nutritionProfile }
    }

    static var mock: MealItem {
        .init(name: "Omelette with ham and cheese", subTitle: nil,
              ingredients: Ingredient.mockArray)
    }

    static var mockWithSubTitle: MealItem {
        .init(name: "Omelette with ham and cheese",
              subTitle: "Omelette Brand",
              ingredients: [Ingredient.mock])
    }
}

extension Array where Element == MealItem {
    var nutritionProfile: NutritionProfile {
        .init(calories: reduce(0) { $0 + $1.nutritionProfile.calories },
              proteins: reduce(0) { $0 + $1.nutritionProfile.proteins },
              fats: reduce(0) { $0 + $1.nutritionProfile.fats },
              carbohydrates: reduce(0) { $0 + $1.nutritionProfile.carbohydrates })
    }
}
