//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation
import SwiftUI

public struct QuestionContent: Hashable {
    let title: String
    let icon: Image
    let answers: [String]

    public init(title: String, icon: Image, answers: [String]) {
        self.title = title
        self.icon = icon
        self.answers = answers
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
