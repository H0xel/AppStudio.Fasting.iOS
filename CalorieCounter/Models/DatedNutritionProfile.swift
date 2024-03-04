//
//  DatedNutritionProfile.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.01.2024.
//

import Foundation

struct DatedNutritionProfile {
    let id: String
    let startDate: Date
    let profile: NutritionProfile

    init(startDate: Date, profile: NutritionProfile) {
        id = UUID().uuidString
        self.startDate = startDate
        self.profile = profile
    }
}
