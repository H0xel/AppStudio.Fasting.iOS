//
//  ArticleStackSize.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

enum ArticleStackSize: String, Codable {
    case small
    case large
}

extension ArticleStackSize {
    var previewSize: ArticlePreviewSize {
        switch self {
        case .small:
                .small
        case .large:
                .large
        }
    }
}
