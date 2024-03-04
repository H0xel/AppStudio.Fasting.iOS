//
//  TopBorderModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI

struct TopBorderModifier: ViewModifier {

    @State private var textFieldHeight: CGFloat = 0

    func body(content: Content) -> some View {
        ZStack {
            Color.studioGreyStrokeFill
                .frame(height: textFieldHeight)
                .corners([.topLeft, .topRight], with: .cornerRadius)
                .offset(y: -.borderWidth)
            content
                .withViewHeightPreferenceKey
        }
        .onViewHeightPreferenceKeyChange { newHeight in
            textFieldHeight = newHeight
        }
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(TopBorderModifier())
}
