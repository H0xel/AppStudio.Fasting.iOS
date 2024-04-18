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
    var voting: MealVoting

    init(type: MealType, dayDate: Date, mealItem: MealItem, voting: MealVoting) {
        self.id = UUID().uuidString
        self.type = type
        self.dayDate = dayDate.startOfTheDay
        self.creationDate = .now
        self.mealItem = mealItem
        self.voting = voting
    }

    init(id: String,
         type: MealType,
         dayDate: Date,
         creationDate: Date,
         mealItem: MealItem,
         voting: MealVoting = .notVoted) {
        self.id = id
        self.type = type
        self.dayDate = dayDate
        self.creationDate = creationDate
        self.mealItem = mealItem
        self.voting = voting
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
              mealItem: mealItem,
              voting: voting)
    }

    func copyWith(ingredients: [Ingredient]) -> Meal {
        .init(id: id,
              type: type,
              dayDate: dayDate,
              creationDate: creationDate,
              mealItem: .init(name: mealItem.name,
                              subTitle: mealItem.subTitle,
                              ingredients: ingredients),
              voting: voting)
    }

    static var mock: Meal {
        .init(type: .breakfast, dayDate: .now, mealItem: .mock, voting: .disabled)
    }
}
