//
//  File.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import MunicornCoreData

extension DailyWaterGoal: EntityMappable {
    public func map(to entity: DailyWaterGoalEntity) {
        entity.id = id
        entity.date = date
        entity.quantity = quantity
    }
    
    public init(entity: DailyWaterGoalEntity) throws {
        guard let id = entity.id,
              let date = entity.date else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.date = date
        self.quantity = entity.quantity
    }
    
    public static var identifierName: String {
        "id"
    }
}
