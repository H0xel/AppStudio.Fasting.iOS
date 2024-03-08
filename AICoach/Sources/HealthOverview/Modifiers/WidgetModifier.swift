//
//  WidgetModifier.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

struct WidgetModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.padding)
            .background(.white)
            .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let padding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
}

#Preview {
    ZStack {
        Color.red
        Text("Hello, world!")
            .modifier(WidgetModifier())
    }
}
