//
//  CoachMessageLeftAlignedModifier.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI

struct CoachMessageLeftAlignedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, .shortPadding)
            .padding(.trailing, .longPadding)
            .aligned(.left)
    }
}

private extension CGFloat {
    static let shortPadding: CGFloat = 16
    static let longPadding: CGFloat = 56
}

#Preview {
    Text("Hello, world!")
        .modifier(CoachMessageLeftAlignedModifier())
}
