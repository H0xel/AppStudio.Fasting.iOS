//
//  OldMealItem.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 07.06.2024.
//

import Foundation

struct OldMealItem: Codable, Hashable {
    let id: String
    let name: String
    let subTitle: String? // brand title
    let ingredients: [OldIngredient]
    let creationType: MealCreationType
    let dateUpdated: Date

    enum CodingKeys: CodingKey {
        case id
        case name
        case subTitle
        case ingredients
        case creationType
        case dateUpdated
    }
}

extension OldMealItem {
    var asMeal: MealItem {
        let totalWeight = ingredients.reduce(0) { $0 + $1.weight }
        return MealItem(id: id,
                 type: creationType,
                 name: name,
                 subTitle: subTitle,
                 notes: nil,
                 ingredients: ingredients.asMealArray,
                 normalizedProfile: .empty,
                 servingMultiplier: 1.0,
                 serving: .defaultServing,
                 servings: .defaultServings,
                 dateUpdated: dateUpdated)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.subTitle = try container.decodeIfPresent(String.self, forKey: .subTitle)
        self.ingredients = try container.decode([OldIngredient].self, forKey: .ingredients)
        self.creationType = try container.decodeIfPresent(MealCreationType.self, forKey: .creationType) ?? .chatGPT
        self.dateUpdated = try container.decodeIfPresent(Date.self, forKey: .dateUpdated) ?? .now
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.subTitle, forKey: .subTitle)
        try container.encode(self.ingredients, forKey: .ingredients)
        try container.encode(self.creationType, forKey: .creationType)
        try container.encode(self.dateUpdated, forKey: .dateUpdated)
    }
}

extension OldIngredient {
    var asMeal: MealItem {
        MealItem(id: "",
                 type: .ingredient,
                 name: name,
                 subTitle: brandTitle,
                 notes: nil,
                 ingredients: [],
                 normalizedProfile: normalizedProfile,
                 servingMultiplier: weight / 100,
                 serving: .defaultServing,
                 servings: .defaultServings,
                 dateUpdated: .now)
    }
}

extension Array where Element == OldIngredient {
    var asMealArray: [MealItem] {
        self.map { $0.asMeal }
    }
}
