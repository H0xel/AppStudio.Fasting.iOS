//
//  WithDimmedViewModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI

struct WithDimmedViewModifier: ViewModifier {

    let onTap: () -> Void

    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            Color.white.opacity(0.05)
                .onTapGesture(perform: onTap)
            content
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(WithDimmedViewModifier {})
}
