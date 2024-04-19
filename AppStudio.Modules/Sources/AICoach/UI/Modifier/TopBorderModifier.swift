//
//  TopBorderModifier.swift
//  
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import Dependencies

struct TopBorderModifier: ViewModifier {

    var color: Color
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
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
