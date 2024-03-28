//
//  ContentWidthTextField.swift
//
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import SwiftUI

public struct ContentWidthTextField: View {

    @Binding var text: String
    let placeholder: String
    @State private var textWidth: CGFloat = 0

    public init(text: Binding<String>,
                placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack {
            Text(text.isEmpty ? placeholder : text)
                .withViewWidthPreferenceKey
                .opacity(0)
            TextField(placeholder, text: $text)
                .frame(width: textWidth)
        }
        .onViewWidthPreferenceKeyChange { newWidth in
            textWidth = newWidth
        }
    }
}

#Preview {
    ContentWidthTextField(text: .constant("Text"), placeholder: "Text")
}
