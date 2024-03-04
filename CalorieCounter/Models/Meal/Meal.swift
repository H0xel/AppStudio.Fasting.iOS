//
//  MealEntry.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 21.12.2023.
//

import Foundation

struct Meal: Hashable, Identifiable {
    let id: String
    let type: MealType
    let dayDate: Date
    let creationDate: Date
    let mealItem: MealItem

    init(type: MealType, dayDate: Date, mealItem: MealItem) {
        self.id = UUID().uuidString
        self.type = type
        self.dayDate = dayDate.beginningOfDay
        self.creationDate = .now
        self.mealItem = mealItem
    }

    init(id: String,
         type: MealType,
         dayDate: Date,
         creationDate: Date,
         mealItem: MealItem) {
        self.id = id
        self.type = type
        self.dayDate = dayDate
        self.creationDate = creationDate
        self.mealItem = mealItem
    }
}

extension Meal {

    var calories: Double {
        mealItem.nutritionProfile.calories
    }

    func copyWith(type: MealType) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: mealItem)
    }

    func copyWith(ingredients: [Ingredient]) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: .init(name: mealItem.name,
                              subTitle: mealItem.subTitle,
                              ingredients: ingredients))
    }

    static var mock: Meal {
        .init(type: .breakfast, dayDate: .now, mealItem: .mock)
    }
}
