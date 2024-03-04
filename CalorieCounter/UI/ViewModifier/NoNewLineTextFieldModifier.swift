//
//  NoNewLineTextFieldModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioUI

struct NoNewLineTextFieldModifier: ViewModifier {

    @Binding var text: String
    let onSubmit: () -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                guard let index = newValue.lastIndex(of: "\n") else {
                    return
                }
                text.remove(at: index)
                if !text.isEmpty {
                    onSubmit()
                    return
                }
                hideKeyboard()
            }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(NoNewLineTextFieldModifier(text: .constant("Hello"), onSubmit: {}))
}
