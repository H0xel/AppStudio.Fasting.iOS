//
//  ParagraphContent.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation

public struct ParagraphContent: Hashable {
    let title: String
    let topics: [String]

    public init(title: String, topics: [String]) {
        self.title = title
        self.topics = topics
    }
}
