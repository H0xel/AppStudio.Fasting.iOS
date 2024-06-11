//
//  DimmedBackgroundModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 04.06.2024.
//

import SwiftUI

struct DimmedBackgroundModifier: ViewModifier {

    let isDimmed: Bool
    let onTap: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            if isDimmed {
                Color.studioBlackLight
                    .opacity(0.2)
                    .onTapGesture(perform: onTap)
            }
            content
                .animation(nil, value: isDimmed)
        }
        .animation(.linear, value: isDimmed)
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(DimmedBackgroundModifier(isDimmed: true) {})
}
