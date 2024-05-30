//
//  MealItem+Mapped.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 01.05.2024.
//

import Foundation
import MunicornCoreData

extension MealItem: EntityMappable {

    init(entity: MealItemEntity) throws {
        guard let id = entity.id,
              let name = entity.name else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.name = name
        subTitle = entity.subtitle
        ingredients = (try? [Ingredient](json: entity.ingredients ?? "")) ?? []
        creationType = MealCreationType(rawValue: Int(entity.creationType)) ?? .chatGPT
        dateUpdated = entity.dateUpdated ?? .now
    }

    func map(to entity: MealItemEntity) {
        entity.id = id
        entity.name = name
        entity.subtitle = subTitle
        entity.ingredients = ingredients.json()
        entity.creationType = Int16(creationType.rawValue)
        entity.dateUpdated = dateUpdated
    }

    static var identifierName: String {
        "id"
    }
}
