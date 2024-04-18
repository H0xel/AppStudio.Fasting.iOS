//
//  DrinkingWater+mapped.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import MunicornCoreData

extension DrinkingWater: EntityMappable {

    public init(entity: DrinkingWaterEntity) throws {
        guard let id = entity.id,
              let date = entity.date else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.date = date
        self.quantity = entity.quantity
    }

    public func map(to entity: DrinkingWaterEntity) {
        entity.id = id
        entity.date = date
        entity.quantity = quantity
    }

    public static var identifierName: String {
        "id"
    }
}
