//
//  MealCreationType.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 02.05.2024.
//

import Foundation

enum MealCreationType: Int, Codable {
    case chatGPT
    case quickAdd
    case custom
    case product
    case recipe
    case ingredient
    case needToUpdateBrand
}
