//
//  Ingredient.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import Foundation

struct Ingredient: Codable, Hashable {
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

extension Ingredient {
    var nutritionProfile: NutritionProfile {
        normalizedProfile.calculate(for: weight)
    }

    static var mock: Ingredient {
        .init(name: "Egg",
              brandTitle: nil,
              weight: 150.0,
              normalizedProfile: NutritionProfile(calories: 220.0,
                                                  proteins: 18.0,
                                                  fats: 15.0,
                                                  carbohydrates: 1.0).normalize(with: 150))
    }

    static var mockArray: [Ingredient] {
        [
            Ingredient(name: "Egg",
                       brandTitle: nil,
                       weight: 150.0,
                       normalizedProfile: NutritionProfile(calories: 220.0,
                                                           proteins: 18.0,
                                                           fats: 15.0,
                                                           carbohydrates: 1.0).normalize(with: 150)),
            Ingredient(name: "Cheese",
                       brandTitle: nil,
                       weight: 20.0,
                       normalizedProfile: NutritionProfile(calories: 80,
                                                           proteins: 6.0,
                                                           fats: 6.0,
                                                           carbohydrates: 1.0).normalize(with: 20.0)),
            Ingredient(name: "Ham",
                       brandTitle: nil,
                       weight: 30.0,
                       normalizedProfile: NutritionProfile(calories: 30.0,
                                                           proteins: 40.0,
                                                           fats: 6.0,
                                                           carbohydrates: 2.0).normalize(with: 30))
        ]
    }

    func updated(newWeight: CGFloat) -> Ingredient {
        .init(name: name, brandTitle: brandTitle, weight: newWeight, normalizedProfile: normalizedProfile)
    }
}
