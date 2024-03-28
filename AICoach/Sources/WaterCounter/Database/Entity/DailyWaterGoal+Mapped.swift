//
//  File.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import MunicornCoreData

extension DailyWaterGoal: EntityMappable {
    func map(to entity: DailyWaterGoalEntity) {
        entity.id = id
        entity.date = date
        entity.quantity = quantity
    }
    
    init(entity: DailyWaterGoalEntity) throws {
        guard let id = entity.id,
              let date = entity.date else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.date = date
        self.quantity = entity.quantity
    }
    
    static var identifierName: String {
        "id"
    }
}
