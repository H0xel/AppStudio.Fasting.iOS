//
//  BottomHealthWidgetHintModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioModels

public struct BottomHealthWidgetHintModifier: ViewModifier {

    let isHintPresented: Bool
    let hint: HealthWidgetHint
    let onClose: () -> Void
    let onLearnMore: () -> Void

    public init(isHintPresented: Bool,
                hint: HealthWidgetHint,
                onClose: @escaping () -> Void,
                onLearnMore: @escaping () -> Void) {
        self.isHintPresented = isHintPresented
        self.hint = hint
        self.onClose = onClose
        self.onLearnMore = onLearnMore
    }

    public func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            content
            if isHintPresented {
                HealthWidgetHintView(hint: hint,
                                     position: .bottom,
                                     onHide: onClose,
                                     onLearnMore: onLearnMore)
                .zIndex(-1)
                .transition(.asymmetric(insertion: .identity,
                                        removal: .push(from: .bottom)))
            }
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(BottomHealthWidgetHintModifier(isHintPresented: true,
                                                 hint: .weight,
                                                 onClose: {},
                                                 onLearnMore: {}))
}
