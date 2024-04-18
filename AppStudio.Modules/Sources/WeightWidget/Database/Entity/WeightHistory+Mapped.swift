//
//  WeightHistory+Mapped.swift
//
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import MunicornCoreData

extension WeightHistory: EntityMappable {

    public init(entity: WeightHistoryEntity) throws {
        guard let id = entity.id,
              let dateCreate = entity.dateCreated,
              let historyDate = entity.historyDate,
              let units = entity.unit else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.dateCreated = dateCreate
        self.weightUnits = .init(rawValue: units) ?? .kg
        self.scaleWeightValue = entity.scaleWeightValue
        self.trueWeightValue = entity.trueWeightValue
        self.historyDate = historyDate.startOfTheDay
    }

    public func map(to entity: WeightHistoryEntity) {
        entity.id = id
        entity.dateCreated = dateCreated
        entity.unit = weightUnits.rawValue
        entity.scaleWeightValue = scaleWeightValue
        entity.trueWeightValue = trueWeightValue
        entity.historyDate = historyDate.startOfTheDay
    }

    public static var identifierName: String {
        "id"
    }
}
