//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import MunicornCoreData

extension CoachMessage: EntityMappable {

    init(entity: CoachMessageEntity) throws {
        guard let id = entity.id,
              let runId = entity.runId,
              let text = entity.text,
              let sender = entity.sender,
              let date = entity.dateCreated else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.runId = runId
        self.text = text
        self.sender = CoachMessageSender(rawValue: sender) ?? .user
        self.date = date
    }

    func map(to entity: CoachMessageEntity) {
        entity.id = id
        entity.runId = runId
        entity.text = text
        entity.dateCreated = date
        entity.sender = sender.rawValue
    }

    static var identifierName: String {
        "id"
    }
}
