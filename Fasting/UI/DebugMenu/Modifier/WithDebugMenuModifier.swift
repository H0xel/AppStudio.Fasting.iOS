//
//  WithDebugMenuModifier.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI
import AppStudioUI

struct WithDebugMenuModifier: ViewModifier {

    @State private var debugMenuIsPresented = false

    func body(content: Content) -> some View {
        content
            .onShake(isDebug: UIDevice.current.isSandbox) {
                debugMenuIsPresented = true
            }
            .fullScreenCover(isPresented: $debugMenuIsPresented) {
                DebugMenuScreen()
            }
    }
}

extension View {
    func withDebugMenu() -> some View {
        modifier(WithDebugMenuModifier())
    }
}
