//
//  ArticleFiles.swift
//  
//
//  Created by Denis Khlopin on 30.04.2024.
//

import Foundation

struct ArticleFiles {
    var id: String
    var articleName: String
    var jsonFile: String?
    var pngFile: String?
    var markdownFile: String?
    var updatedAt: Date?

    var isValid: Bool {
        updatedAt != nil && jsonFile != nil && pngFile != nil && markdownFile != nil
    }
}
