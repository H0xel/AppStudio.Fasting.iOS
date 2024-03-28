//
//  ContentWidthBadge.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import SwiftUI

public struct ContentWidthBadge: Hashable {
    let title: String
    let badgeTitle: String
    let badgeColor: Color
    let content: [String]

    public init(title: String, badgeTitle: String, badgeColor: Color, content: [String]) {
        self.title = title
        self.badgeTitle = badgeTitle
        self.badgeColor = badgeColor
        self.content = content
    }
}
