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

    @State private var textFieldHeight: CGFloat = 0

    func body(content: Content) -> some View {
        ZStack {
            color
                .frame(height: textFieldHeight)
                .corners([.topLeft, .topRight], with: cornerRadius)
                .offset(y: -.borderWidth)
            Color.white
                .frame(height: textFieldHeight)
                .corners([.topLeft, .topRight], with: cornerRadius)
            content
                .withViewHeightPreferenceKey
        }
        .onViewHeightPreferenceKeyChange { newHeight in
            textFieldHeight = newHeight
        }
    }
}

private extension CGFloat {
    static let borderWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(TopBorderModifier(color: .gray))
}
