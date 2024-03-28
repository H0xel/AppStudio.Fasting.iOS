//
//  NovaQustionsContent.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import SwiftUI

public struct NovaQustionsContent: Hashable {
    let icon: Image
    let title: String
    let questions: [String]

    public init(title: String, icon: Image, questions: [String]) {
        self.title = title
        self.questions = questions
        self.icon = icon
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(questions)
    }
}
