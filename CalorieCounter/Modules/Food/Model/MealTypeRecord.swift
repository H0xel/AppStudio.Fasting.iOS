//
//  MealTypeRecord.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import Foundation

struct MealTypeRecord {
    let type: MealType
    let meals: [Meal]

    var calories: Double {
        meals.reduce(0) { $0 + $1.calories }
    }

    var nutritionProfile: NutritionProfile {
        meals.reduce(.empty) { $0 ++ $1.mealItem.nutritionProfile }
    }
}