//
//  CustomKeyboardScrollView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.06.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles

struct CustomKeyboardScrollView<Content: View>: View {

    let isKeyboardPresented: Bool
    let onScroll: () -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            content()
            if isKeyboardPresented {
                Spacer(minLength: .keyboardHeight)
            }
        }
        .simultaneousGesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { _ in
                    onScroll()
                }
        )
    }
}

private extension CGFloat {
    static let keyboardHeight: CGFloat = 387
}

#Preview {
    CustomKeyboardScrollView(isKeyboardPresented: true, onScroll: {}) {
        Text("Hello World!")
    }
}
