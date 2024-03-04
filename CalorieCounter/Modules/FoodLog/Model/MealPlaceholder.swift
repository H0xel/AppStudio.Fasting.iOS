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
    var notFound: Bool

    init(mealText: String, notFound: Bool = false) {
        id = UUID().uuidString
        self.mealText = mealText
        self.notFound = notFound
    }
}
