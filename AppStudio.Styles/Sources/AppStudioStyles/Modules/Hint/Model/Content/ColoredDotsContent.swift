//
//  ColoredDotsContent.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import SwiftUI

public struct ColoredDotsContent: Hashable {
    let title: String
    let phases: [ColoredDot]

    public init(title: String, phases: [ColoredDot]) {
        self.title = title
        self.phases = phases
    }
}

public struct ColoredDot: Hashable {
    let color: Color
    let title: String

    public init(color: Color, title: String) {
        self.color = color
        self.title = title
    }
}
