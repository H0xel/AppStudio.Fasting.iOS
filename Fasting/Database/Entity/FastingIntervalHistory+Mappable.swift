//
//  FastingIntervalHistory+Mappable.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Foundation
import MunicornCoreData

extension FastingIntervalHistory: EntityMappable {
    func map(to entity: FastingIntervalHistoryEntity) {
        entity.id = id
        entity.startedDate = startedDate
        entity.finishedDate = finishedDate
        entity.currentDate = currentDate
        entity.plan = Int16(plan.rawValue)
    }

    init(entity: FastingIntervalHistoryEntity) throws {
        guard let id = entity.id,
              let startedDate = entity.startedDate,
              let finishedDate = entity.finishedDate,
              let currentDate = entity.currentDate else {
            throw CoreDataError.databaseWrongEntity
        }

        self.id = id
        self.startedDate = startedDate
        self.finishedDate = finishedDate
        self.currentDate = currentDate
        self.plan = FastingPlan(rawValue: Int(entity.plan)) ?? .beginner
    }

    static var identifierName: String {
        "id"
    }
}
