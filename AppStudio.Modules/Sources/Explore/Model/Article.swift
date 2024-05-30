//
//  Article.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

struct Article: Codable, Hashable, Identifiable {
    let id: String
    let stackId: String
    let free: Bool
    let title: String
    let type: ArticleType
    let cookTime: Int?
    let readTime: Int?
    let nutritionProfile: ArticleNutritionProfile?
    let modifiedDate: Date
    var imageURL: String
    var content: String
    var isFavorite: Bool

    var imageId: String {
        imageURL.replacingOccurrences(of: "/", with: "**").replacingOccurrences(of: ".png", with: "")
    }
}

enum ArticleType: String, Codable {
    case article
    case recipe
}

extension Article {
    static var mock: Article {
        .init(id: UUID().uuidString,
              stackId: UUID().uuidString,
              free: true, 
              title: "Vegan Broccoli Pizza Crust with Spring Vegetables", 
              type: .article, 
              cookTime: 15, 
              readTime: 15, 
              nutritionProfile: .mock, 
              modifiedDate: .now, 
              imageURL: "", 
              content: "## Why you love it\n- [ ]  Just a slight, subtle spinach flavour\n\n- [ ]  They keep well and are ideal for travel. Ideal for snacking\n\n- [ ]  Just a slight, subtle spinach flavour\n\n ## Ingredients\n| 10 servings   |    |\n| --- | --- |\n| **4** | all purpose flour|\n---\n ## Recipe Notes\n- **Preheat the pan**  \n`if your first pancake breaks, it’s probably because the pan isn’t hot enough. Give it a little more time to heat fully before trying the second`.", 
              isFavorite: true)
    }
}
