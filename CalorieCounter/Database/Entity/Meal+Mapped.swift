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
              let mealItem = try? MealItem(json: mealItemJson),
              let type = MealType(rawValue: entity.type ?? "") else {
            throw CoreDataError.databaseWrongEntity
        }

        self.id = id
        self.dayDate = dayDate
        self.type = type
        self.mealItem = mealItem
        self.creationDate = creationDate
    }

    static var identifierName: String {
        "id"
    }

    func map(to entity: MealEntity) {
        entity.id = id
        entity.dayDate = dayDate
        entity.creationDate = creationDate
        entity.type = type.rawValue
        entity.mealItemJson = mealItem.json()
    }
}
