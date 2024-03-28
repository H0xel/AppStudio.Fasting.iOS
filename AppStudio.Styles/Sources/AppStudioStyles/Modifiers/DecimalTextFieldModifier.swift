//
//  SwiftUIView.swift
//  
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import SwiftUI

public struct DecimalTextFieldModifier: ViewModifier {

    @Binding private var text: String
    @Binding private var decimalValue: Double

    public init(text: Binding<String>, decimalValue: Binding<Double>) {
        self._text = text
        self._decimalValue = decimalValue
    }

    public func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
            .onChange(of: text) { newValue in
                let numbers = newValue.filter { $0.isNumber }
                guard !numbers.isEmpty else {
                    text = ""
                    decimalValue = 0
                    return
                }
                let punctuation = newValue.filter { !$0.isNumber }
                guard punctuation.count <= 1 else {
                    _ = text.popLast()
                    return
                }
                if let separator = punctuation.first,
                   let index = newValue.map({ $0 }).firstIndex(of: separator),
                    newValue.count - index > 3 {
                    _ = text.popLast()
                    return
                }
                let newValue = newValue.isEmpty ? "0" : newValue.replacingOccurrences(of: ",", with: ".")
                if let doubleValue = Double(newValue) {
                    decimalValue = doubleValue
                }
            }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(DecimalTextFieldModifier(text: .constant(""), decimalValue: .constant(0)))
}
