//
//  TopBorderModifier.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI

struct TopBorderModifier: ViewModifier {

    var color: Color = .fastingGreyStrokeFill
    var cornerRadius: CGFloat = 20

    @State private var textFieldHeight: CGFloat = 0

    func body(content: Content) -> some View {
        ZStack {
            color
                .frame(height: textFieldHeight)
                .corners([.topLeft, .topRight], with: cornerRadius)
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
    static let borderWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(TopBorderModifier())
}
