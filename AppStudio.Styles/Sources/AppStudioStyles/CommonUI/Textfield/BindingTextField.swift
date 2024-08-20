//
//  BindingTextField.swift
//
//
//  Created by Руслан Сафаргалеев on 19.08.2024.
//

import SwiftUI

public struct BindingTextField: View {

    @Binding var text: String
    let placeholder: String

    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        TextField(
            "",
            text: .init(
                get: { text },
                set: { text in self.text = text }
            ),
            prompt: Text(placeholder).foregroundColor(.studioGreyPlaceholder),
            axis: .vertical
        )
    }
}

#Preview {
    BindingTextField(text: .constant("hello"), placeholder: "world")
}
