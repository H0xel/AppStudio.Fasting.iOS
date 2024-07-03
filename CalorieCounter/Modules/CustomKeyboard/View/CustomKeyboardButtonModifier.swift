//
//  CustomKeyboardButtonModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioUI

struct CustomKeyboardButtonModifier: ViewModifier {

    var backgroundColor: Color = .white

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: .height)
            .background(backgroundColor)
            .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 5
    static let height: CGFloat = 47
}

#Preview {
    Text("5")
        .modifier(CustomKeyboardButtonModifier())
}
