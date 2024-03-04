//
//  NutritionProfile+Mapped.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.01.2024.
//

import MunicornCoreData

extension DatedNutritionProfile: EntityMappable {

    init(entity: NutritionProfileEntity) throws {
        guard let id = entity.id, let startDate = entity.startDate else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.startDate = startDate
        profile = .init(calories: entity.calories,
                        proteins: entity.proteins,
                        fats: entity.fats,
                        carbohydrates: entity.carbohydrates)
    }

    func map(to entity: NutritionProfileEntity) {
        entity.id = id
        entity.calories = profile.calories
        entity.fats = profile.fats
        entity.carbohydrates = profile.carbohydrates
        entity.proteins = profile.proteins
        entity.startDate = startDate
    }

    static var identifierName: String {
        "id"
    }
}
