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
    var dayDate: Date
    let creationDate: Date
    let mealItem: MealItem
    var voting: MealVoting
    var servingMultiplier: Double

    init(type: MealType, dayDate: Date, mealItem: MealItem, voting: MealVoting) {
        self.id = UUID().uuidString
        self.type = type
        self.dayDate = dayDate.startOfTheDay
        self.creationDate = .now
        self.mealItem = mealItem
        self.voting = voting
        self.servingMultiplier = 1.0
    }

    init(id: String,
         type: MealType,
         dayDate: Date,
         creationDate: Date,
         mealItem: MealItem,
         voting: MealVoting = .notVoted,
         servingMultiplier: Double = 1.0) {
        self.id = id
        self.type = type
        self.dayDate = dayDate
        self.creationDate = creationDate
        self.mealItem = mealItem
        self.voting = voting
        self.servingMultiplier = servingMultiplier
    }
}

extension Meal {
    var isMealNeedToSave: Bool {
        !isQuickAdded
    }

    var calories: Double {
        mealItem.nutritionProfile.calories
    }

    var isQuickAdded: Bool {
        mealItem.type == .quickAdd
    }

    func copyWith(type: MealType) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: mealItem,
              voting: voting, 
              servingMultiplier: servingMultiplier)
    }

    func copyWith(ingredients: [IngredientStruct]) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: mealItem.updated(ingredients: ingredients),
              voting: voting,
              servingMultiplier: servingMultiplier)
    }

    func copyWith(name: String, normalizedProfile: NutritionProfile) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: mealItem.updated(name: name, normalizedProfile: normalizedProfile),
              voting: voting,
              servingMultiplier: servingMultiplier)
    }

    func copyWith(mealItem: MealItem) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: mealItem,
              voting: voting,
              servingMultiplier: servingMultiplier)
    }

    static var mock: Meal {
        .init(type: .breakfast, dayDate: .now, mealItem: .mock, voting: .disabled)
    }
}
