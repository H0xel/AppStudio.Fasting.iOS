//
//  MealItem.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct MealItem: Codable, Hashable {
    let id: String
    let name: String
    let subTitle: String?
    let ingredients: [Ingredient]
    let creationType: MealCreationType
    let dateUpdated: Date

    enum CodingKeys: CodingKey {
        case id
        case name
        case subTitle
        case ingredients
        case creationType
        case dateUpdated
    }

    init(id: String,
         name: String,
         subTitle: String?,
         ingredients: [Ingredient],
         creationType: MealCreationType,
         dateUpdated: Date) {
        self.id = id
        self.name = name
        self.subTitle = subTitle
        self.ingredients = ingredients
        self.creationType = creationType
        self.dateUpdated = dateUpdated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.subTitle = try container.decodeIfPresent(String.self, forKey: .subTitle)
        self.ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        self.creationType = try container.decodeIfPresent(MealCreationType.self, forKey: .creationType) ?? .chatGPT
        self.dateUpdated = try container.decodeIfPresent(Date.self, forKey: .dateUpdated) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.subTitle, forKey: .subTitle)
        try container.encode(self.ingredients, forKey: .ingredients)
        try container.encode(self.creationType, forKey: .creationType)
        try container.encode(self.dateUpdated, forKey: .dateUpdated)
    }
}

extension MealItem {
    var weight: Double {
        ingredients.reduce(0) { $0 + $1.weight }
    }

    var weightWithUnits: String {
        let weight = String(format: "%.0f", weight)
        let label = "Ingredient.weightLabel".localized()
        return "\(weight) \(label)"
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
        .init(id: UUID().uuidString,
              name: "Omelette with ham and cheese",
              subTitle: nil,
              ingredients: Ingredient.mockArray,
              creationType: .chatGPT,
              dateUpdated: .now)
    }

    static var mockWithSubTitle: MealItem {
        .init(id: UUID().uuidString,
              name: "Omelette with ham and cheese",
              subTitle: "Omelette Brand",
              ingredients: [Ingredient.mock],
              creationType: .chatGPT,
              dateUpdated: .now)
    }

    static var mockQuickAdd: MealItem {
        .init(id: UUID().uuidString,
              name: "Omelette",
              subTitle: nil,
              ingredients: [Ingredient.mock],
              creationType: .quickAdd,
              dateUpdated: .now)
    }

    static var mockQuickAddWithTitle: MealItem {
        .init(id: UUID().uuidString,
              name: "Omelette",
              subTitle: nil,
              ingredients: [Ingredient.mock],
              creationType: .quickAdd,
              dateUpdated: .now)
    }

    func updated(ingredients: [Ingredient]) -> MealItem {
        .init(id: id,
              name: name,
              subTitle: subTitle,
              ingredients: ingredients,
              creationType: creationType,
              dateUpdated: self.ingredients == ingredients ? dateUpdated : .now)
    }

    func updated(name: String) -> MealItem {
        .init(id: id,
              name: name,
              subTitle: subTitle,
              ingredients: ingredients,
              creationType: creationType,
              dateUpdated: dateUpdated)
    }

    static func quickAdded(foodName: String, nutritionProfile profile: NutritionProfile) -> MealItem {
        .init(id: UUID().uuidString,
              name: "",
              subTitle: nil,
              ingredients: [
                .init(name: foodName,
                      brandTitle: nil,
                      weight: 100,
                      normalizedProfile: profile)
              ],
              creationType: .quickAdd,
              dateUpdated: .now)
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
