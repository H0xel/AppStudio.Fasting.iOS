//
//  WeightGoal+Mapped.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import MunicornCoreData
import AppStudioModels

extension WeightGoal: EntityMappable {
    public init(entity: WeightGoalEntity) throws {
        guard let id = entity.id,
              let dateCreate = entity.dateCreated,
              let units = entity.weightUnit else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.dateCreated = dateCreate
        self.goal = entity.goal
        self.weightUnit = WeightUnit(rawValue: units) ?? .lb
        self.start = entity.start
    }

    public func map(to entity: WeightGoalEntity) {
        entity.id = id
        entity.dateCreated = dateCreated
        entity.goal = goal
        entity.weightUnit = weightUnit.rawValue
        entity.start = start
    }

    public static var identifierName: String {
        "id"
    }
}
