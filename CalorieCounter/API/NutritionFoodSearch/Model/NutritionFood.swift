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
    let brandedFoodId: String?
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
        let nutritionProfile: NutritionProfile = .init(calories: calories ?? 0, proteins: protein ?? 0, fats: fat ?? 0, carbohydrates: carbohydrate ?? 0)

        let serving = MealServing(
            weight: servingWeightGrams,
            measure: servingUnit,
            quantity: servingQuantity
        )

        let multiplier = serving.multiplier(for: 1.0 * serving.quantity)

        let result = MealItem(
            id: UUID().uuidString,
            type: .ingredient,
            name: foodName.capitalized,
            subTitle: brandName?.capitalized,
            brandFoodId: brandedFoodId,
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
            servingMultiplier: multiplier,
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
            brandFoodId: brandedFoodId,
            notes: nil,
            ingredients: [IngredientStruct(mealItem: ingredient)],
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
