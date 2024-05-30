//
//  TopBorderModifier.swift
//  
//
//  Created by Руслан Сафаргалеев on 07.05.2024.
//

import SwiftUI
import Dependencies

public struct TopBorderModifier: ViewModifier {

    private let color: Color
    private let cornerRadius: CGFloat

    public init(color: Color = .studioGreyStrokeFill, cornerRadius: CGFloat = 20) {
        self.color = color
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .background(
                color
                    .corners([.topLeft, .topRight], with: cornerRadius)
                    .offset(y: -.borderWidth)
            )
    }
}

private extension CGFloat {
    static let borderWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(TopBorderModifier(color: .gray))
}

