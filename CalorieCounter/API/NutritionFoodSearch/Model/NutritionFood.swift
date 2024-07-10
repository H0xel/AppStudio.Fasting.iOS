//
//  NutritionFood.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Foundation

// API Structs
struct NutritionFood: Codable {
    let foodName: String
    let brandName: String?
    let servingQuantity: Double
    let servingUnit: String
    let servingWeightGrams: Double?
    // base
    let calories: Double?
    let fat: Double?
    let carbohydrate: Double?
    let protein: Double?

    // secondary - optional
    let saturedFat: Double?
    let cholesterol: Double?
    let sodium: Double?
    let dietaryFiber: Double?
    let sugars: Double?
    let potassium: Double?

    let altMeasures: [NutritionFoodMeasure]
}

extension NutritionFood {
    var asIngredientMealItem: MealItem? {
        var nutritionProfile: NutritionProfile = .empty

        if let calories, let protein, let carbohydrate, let fat {
            nutritionProfile = .init(calories: calories, proteins: protein, fats: fat, carbohydrates: carbohydrate)
        }

        let serving = MealServing(
            weight: servingWeightGrams,
            measure: servingUnit,
            quantity: servingQuantity
        )

        let result = MealItem(
            id: UUID().uuidString,
            type: .ingredient,
            name: foodName,
            subTitle: brandName,
            notes: nil,
            ingredients: [],
            normalizedProfile: nutritionProfile.normalize(with: servingWeightGrams ?? 100),
            additionInfo: MealAdditionalInfo(
                saturedFat: saturedFat,
                cholesterol: cholesterol,
                sodium: sodium,
                dietaryFiber: dietaryFiber,
                sugars: sugars,
                potassium: potassium
            ),
            totalWeight: nil,
            servingMultiplier: serving.multiplier(for: 1.0 * serving.quantity),
            serving: serving,
            servings: altMeasures.asServings,
            dateUpdated: .now
        )

        return result
    }
    var asMeal: MealItem? {
        guard let ingredient = self.asIngredientMealItem else {
            return nil
        }
        let result = MealItem(
            id: UUID().uuidString,
            type: .custom,
            name: "",
            subTitle: nil,
            notes: nil,
            ingredients: [ingredient],
            normalizedProfile: .empty,
            additionInfo: nil,
            totalWeight: nil,
            servingMultiplier: 1.0,
            serving: .serving,
            servings: [.serving],
            dateUpdated: .now
        )

        return result
    }
}