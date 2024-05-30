//
//  MealUsage.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Foundation

struct MealUsage {
    let id: String
    let usage: Int
    let mealId: String
    let mealType: MealType
}

extension MealUsage {
    var incremented: MealUsage {
        .init(id: id,
              usage: usage + 1,
              mealId: mealId,
              mealType: mealType)
    }

    var decremented: MealUsage {
        .init(id: id,
              usage: usage - 1,
              mealId: mealId,
              mealType: mealType)
    }
}
