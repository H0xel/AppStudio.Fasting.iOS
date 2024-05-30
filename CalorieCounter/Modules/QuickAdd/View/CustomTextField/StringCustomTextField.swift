//
//  StringCustomTextField.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 15.05.2024.
//

import SwiftUI

struct StringValidateSettings {
    let maxChars: Int = 1000
}

struct StringCustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var value: String
    let settings: CustomTextFieldSettings
    var validateSettings: StringValidateSettings = .init()
    var isKeyboardFocused: Bool?
    @State private var stringValue: String = ""

    var body: some View {
        CustomTextField(title: title,
                        placeholder: placeholder,
                        value: $stringValue,
                        settings: settings,
                        isKeyboardFocused: isKeyboardFocused,
                        onValidateValue: onValidate)
        .onChange(of: value) { newValue in
            stringValue = newValue
        }
        .onAppear {
            stringValue = value
        }
    }

    func toString(doubleValue: Double) -> String {
        if doubleValue == 0.0 {
            return ""
        }
        var stringValue = "\(doubleValue)"
        if Double(Int(doubleValue)) == doubleValue {
            stringValue = "\(Int(doubleValue))"
        }

        return stringValue
    }

    func onValidate(stringValue: String) -> String {
        let valideString = String(stringValue.prefix(validateSettings.maxChars))
        value = valideString
        return valideString
    }
}
