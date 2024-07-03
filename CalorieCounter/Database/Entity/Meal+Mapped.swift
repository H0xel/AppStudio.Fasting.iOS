//
//  Meal+Mapped.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 21.12.2023.
//

import MunicornCoreData

extension Meal: EntityMappable {
    init(entity: MealEntity) throws {
        guard let id = entity.id,
              let dayDate = entity.dayDate,
              let creationDate = entity.creationDate,
              let mealItemJson = entity.mealItemJson,
              let mealItem = (try? MealItem(json: mealItemJson)) ?? (try? OldMealItem(json: mealItemJson))?.asMeal,
              let type = MealType(rawValue: entity.type ?? "") else {
            throw CoreDataError.databaseWrongEntity
        }

        self.id = id
        self.dayDate = dayDate.startOfTheDay
        self.type = type
        self.mealItem = mealItem
        self.creationDate = creationDate
        self.voting = MealVoting(rawValue: entity.voting) ?? .notVoted
        self.servingMultiplier = entity.servingMultiplier <= 0 ? entity.servingMultiplier : 1.0
    }

    static var identifierName: String {
        "id"
    }

    func map(to entity: MealEntity) {
        entity.id = id
        entity.dayDate = dayDate.startOfTheDay
        entity.creationDate = creationDate
        entity.type = type.rawValue
        entity.mealItemJson = mealItem.json()
        entity.voting = voting.rawValue
        entity.servingMultiplier = servingMultiplier
    }
}
