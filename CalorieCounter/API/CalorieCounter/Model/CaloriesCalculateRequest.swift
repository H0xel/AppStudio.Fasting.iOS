//
//  CaloriesCalculateRequest.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

struct CaloriesCalculateRequest: Codable {
    let foodText: String
    let promptType: CaloriesCalculatePromtType?
}

enum CaloriesCalculatePromtType: String, Codable {
    case food
    case ingredients
}
