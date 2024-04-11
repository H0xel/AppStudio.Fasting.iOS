//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import MunicornCoreData

extension WaterSettings: EntityMappable {

    public init(entity: WaterSettingsEntity) throws {
        guard let id = entity.id,
              let date = entity.date,
              let unitsRawValue = entity.units else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.date = date
        self.prefferedValue = entity.prefferedValue
        self.units = WaterUnits(rawValue: unitsRawValue) ?? .liters
    }

    public func map(to entity: WaterSettingsEntity) {
        entity.id = id
        entity.date = date
        entity.prefferedValue = prefferedValue
        entity.units = units.rawValue
    }

    public static var identifierName: String {
        "id"
    }
}
