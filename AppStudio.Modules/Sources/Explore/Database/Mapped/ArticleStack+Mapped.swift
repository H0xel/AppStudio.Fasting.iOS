//
//  ArticleStack+Mapped.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Foundation
import MunicornCoreData

extension ArticleStack: EntityMappable {

    init(entity: ArticleStackEntity) throws {
        guard let id = entity.id,
              let sizeString = entity.size,
              let size = ArticleStackSize(rawValue: sizeString),
              let title = entity.title else {
            throw CoreDataError.databaseWrongEntity
        }
        let modifiedDate = entity.modifiedDate ?? Date(timeIntervalSince1970: .hour) // задаем оочень старое время
        self.id = id
        self.size = size
        self.title = title
        self.novaTricks = try? NovaTricks(json: entity.novaTricks ?? "")
        self.modifiedDate = modifiedDate
    }

    func map(to entity: ArticleStackEntity) {
        entity.id = id
        entity.size = size.rawValue
        entity.title = title
        entity.novaTricks = novaTricks?.json()
        entity.modifiedDate = modifiedDate
    }

    static var identifierName: String {
        "id"
    }
}
