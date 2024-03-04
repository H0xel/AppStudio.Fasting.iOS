//
//  CodableCache+Mapped.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.01.2024.
//

import MunicornCoreData

extension CodableCache: EntityMappable {
    func map(to entity: CodableCacheEntity) {
        entity.id = id
        entity.key = key
        entity.type = type.rawValue
        entity.value = value
        entity.date = date
    }

    init(entity: CodableCacheEntity) throws {
        guard let id = entity.id,
                let key = entity.key,
              let type = CodableCacheType(rawValue: entity.type),
              let date = entity.date,
              let value = entity.value else {
            fatalError("wrong cache entity data!")
        }

        self.init(id: id,
                  key: key,
                  type: type,
                  date: date,
                  value: value)
    }

    static var identifierName: String {
        "id"
    }
}
