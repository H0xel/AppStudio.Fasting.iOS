//
//  HintTopic.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation

public struct HintTopic {
    let title: String
    let content: [HintContent]

    public init(title: String, content: [HintContent]) {
        self.title = title
        self.content = content
    }
}
