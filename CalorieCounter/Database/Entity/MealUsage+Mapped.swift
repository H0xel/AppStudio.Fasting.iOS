//
//  MealUsage+Mapped.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Foundation
import MunicornCoreData

extension MealUsage: EntityMappable {

    init(entity: MealUsageEntity) throws {
        guard let id = entity.id,
              let mealId = entity.mealId,
              let mealTypeString = entity.mealType,
              let mealType = MealType(rawValue: mealTypeString) else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.mealId = mealId
        self.mealType = mealType
        usage = Int(entity.usage)
    }

    func map(to entity: MealUsageEntity) {
        entity.id = id
        entity.mealId = mealId
        entity.mealType = mealType.rawValue
        entity.usage = Int64(usage)
    }

    static var identifierName: String {
        "id"
    }
}
