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
    public let cornerRadius: CGFloat
    public let font: Font
    public let action: () -> Void

    public init(title: String?,
                image: Image?,
                backgroundColor: Color? = nil,
                foregroundColor: Color? = nil,
                buttonWidth: CGFloat,
                cornerRadius: CGFloat = 0,
                font: Font = .poppins(.body),
                action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.buttonWidth = buttonWidth
        self.action = action
        self.cornerRadius = cornerRadius
        self.font = font
    }
}

public extension SwipeAction {
    static func delete(onTap: @escaping () -> Void) -> SwipeAction {
        .init(title: "SwipeAction.delete".localized(bundle: .module),
              image: nil,
              backgroundColor: .studioRed,
              foregroundColor: .white,
              buttonWidth: 79,
              action: onTap)
    }
}
