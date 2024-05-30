//
//  File.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

struct ArticleApi: Codable {
    let free: Bool
    let title: String
    let type: ArticleType
    let cookTime: Int?
    let readTime: Int?
    let nutritionProfile: ArticleNutritionProfile?
}
