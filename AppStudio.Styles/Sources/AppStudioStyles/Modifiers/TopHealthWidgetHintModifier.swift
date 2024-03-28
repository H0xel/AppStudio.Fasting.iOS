//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioModels

public struct TopHealthWidgetHintModifier: ViewModifier {

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
            if isHintPresented {
                HealthWidgetHintView(hint: hint,
                                     position: .top,
                                     onHide: onClose,
                                     onLearnMore: onLearnMore)
            }
            content
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(TopHealthWidgetHintModifier(isHintPresented: true,
                                              hint: .weight, 
                                              onClose: {},
                                              onLearnMore: {}))
}
