//
//  FastingParameters+Mappable.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import Foundation
import MunicornCoreData

extension FastingParameters: EntityMappable {
    func map(to entity: FastingParametersEntity) {
        entity.id = id
        entity.startDate = start
        entity.plan = Int16(plan.rawValue)
        entity.currentDate = currentDate
        entity.creationDate = creationDate
    }

    init(entity: FastingParametersEntity) throws {
        guard
            let id = entity.id,
            let startDate = entity.startDate,
            let plan = FastingPlan(rawValue: Int(entity.plan)) else {
            throw CoreDataError.databaseWrongEntity
        }

        self.id = id
        self.start = startDate
        self.plan = plan
        self.currentDate = entity.currentDate
        self.creationDate = entity.creationDate ?? .utcNow
    }

    static var identifierName: String {
        "id"
    }
}
