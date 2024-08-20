//
//  MealPlaceholder.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 27.12.2023.
//

import Foundation

struct MealPlaceholder: Hashable {
    let id: String
    let mealText: String
    let type: MealPlaceholderType
    var notFound: Bool

    init(mealText: String, type: MealPlaceholderType, notFound: Bool = false) {
        id = UUID().uuidString
        self.mealText = mealText
        self.type = type
        self.notFound = notFound
    }
}

enum MealPlaceholderType {
    case barcode
    case ai
}
