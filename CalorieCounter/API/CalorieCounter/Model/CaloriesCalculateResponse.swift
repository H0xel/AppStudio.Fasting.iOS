//
//  CaloriesCalculateResponse.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import Foundation

struct CaloriesCalculateResponse: Codable {
    let meals: [ApiMeal]

    enum CodingKeys: String, CodingKey {
        case meals = "mls"
    }
}
