//
//  ArticleStackFiles.swift
//  
//
//  Created by Denis Khlopin on 30.04.2024.
//

import Foundation

struct ArticleStackFiles {
    var id: String
    var stackName: String
    var updatedAt: Date?
    var articleFiles: [String: ArticleFiles]
    var infoFile: String?

    var isValid: Bool {
        updatedAt != nil && infoFile != nil && articleFiles.values.reduce(into: true, { $0 = $0 && $1.isValid })
    }
}
