//
//  Articles.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

struct Articles: Codable {
    let stacks: [ArticleStack]
}

extension Articles {
    static var mock: Articles {
        .init(stacks: [.mockSmall, .mockLarge])
    }
}
