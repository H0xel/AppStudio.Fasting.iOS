//
//  Article+Mapped.swift
//  
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import Foundation
import MunicornCoreData

extension Article: EntityMappable {

    init(entity: ArticleEntity) throws {
        guard let id = entity.id,
              let title = entity.title,
              let typeString = entity.type,
              let type = ArticleType(rawValue: typeString),
              let modifiedDate = entity.modifiedDate,
              let imageURL = entity.imageURL,
              let content = entity.content else {
            throw CoreDataError.databaseWrongEntity
        }
        self.id = id
        self.stackId = entity.stackId ?? ""
        self.title = title
        self.type = type
        self.modifiedDate = modifiedDate
        self.imageURL = imageURL
        self.content = content
        free = entity.free
        isFavorite = entity.isFavorite
        cookTime = entity.cookTime > 0 ? Int(entity.cookTime) : nil
        readTime = entity.readTime > 0 ? Int(entity.readTime) : nil
        self.nutritionProfile = try? ArticleNutritionProfile(json: entity.nutritionProfile ?? "")
    }

    func map(to entity: ArticleEntity) {
        entity.id = id
        entity.stackId = stackId
        entity.content = content
        entity.cookTime = Int64(cookTime ?? 0)
        entity.readTime = Int64(readTime ?? 0)
        entity.free = free
        entity.imageURL = imageURL
        entity.isFavorite = isFavorite
        entity.modifiedDate = modifiedDate
        entity.nutritionProfile = nutritionProfile?.json()
        entity.title = title
        entity.type = type.rawValue
    }

    static var identifierName: String {
        "id"
    }
}
