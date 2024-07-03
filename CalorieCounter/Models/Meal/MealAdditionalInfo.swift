//
//  MealAdditionalInfo.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 13.06.2024.
//

import Foundation

struct MealAdditionalInfo: Codable, Hashable {
    let saturedFat: Double?
    let cholesterol: Double?
    let sodium: Double?
    let dietaryFiber: Double?
    let sugars: Double?
    let potassium: Double?
}
