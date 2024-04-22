//
//  Article.swift
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

struct Article: Codable {
    let free: Bool
    let title: String
    let type: ArticleType
    let cookTime: Int?
    let readTime: Int?
    let nutritionProfile: ArticleNutritionProfile?
    var modifiedDate: Date
    var imageURL: String
    var content: String
    var isFavorite: Bool
}

enum ArticleType: Codable {
    case article
    case recipe
}
