//
//  NoNewLineTextFieldModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioUI

struct NoNewLineTextFieldModifier: ViewModifier {

    let availableNumberOfLines: Int
    @Binding var text: String
    let onSubmit: () -> Void

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { newValue in
                let numberOfLines = newValue.components(separatedBy: "\n").count - 1
                if numberOfLines < availableNumberOfLines {
                    return
                }

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
        .modifier(NoNewLineTextFieldModifier(availableNumberOfLines: 5, text: .constant("Hello"), onSubmit: {}))
}
