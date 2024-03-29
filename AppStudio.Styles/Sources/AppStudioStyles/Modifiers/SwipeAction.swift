//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 29.03.2024.
//

import SwiftUI

public struct SwipeAction: Identifiable {
    public let id = UUID().uuidString
    public let title: String?
    public let image: Image?
    public let backgroundColor: Color?
    public let foregroundColor: Color?
    public let buttonWidth: CGFloat
    public let action: () -> Void

    public init(title: String?,
                image: Image?,
                backgroundColor: Color? = nil,
                foregroundColor: Color? = nil,
                buttonWidth: CGFloat,
                action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.buttonWidth = buttonWidth
        self.action = action
    }
}
