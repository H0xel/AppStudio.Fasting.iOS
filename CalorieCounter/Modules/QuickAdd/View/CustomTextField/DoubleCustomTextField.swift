//
//  DoubleCustomTextField.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 15.05.2024.
//

import SwiftUI
struct DoubleValidateSettings {
    let tail: Int = 2
    let min: Double = -1 * .infinity
    let max: Double = .infinity
}

struct DoubleCustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var value: Double
    let settings: CustomTextFieldSettings
    var validateSettings: DoubleValidateSettings = .init()
    var isKeyboardFocused: Bool?
    @State private var stringValue: String = ""

    var body: some View {
        CustomTextField(title: title,
                        placeholder: placeholder,
                        value: $stringValue,
                        settings: settings,
                        isKeyboardFocused: isKeyboardFocused,
                        onValidateValue: onValidate)
        .keyboardType(.decimalPad)
        .onChange(of: value) { newValue in
            stringValue = toString(doubleValue: newValue)
        }
        .onAppear {
            stringValue = toString(doubleValue: value)
        }
    }

    func toString(doubleValue: Double) -> String {
        doubleValue == 0.0 ? "" : doubleValue.stringValueWithCutTail
    }

    private func rollbackValue() -> String {
        value.stringValueWithCutTail
    }

    func onValidate(stringValue: String) -> String {
        if stringValue.isEmpty {
            value = 0
            return ""
        }
        var stringValue = stringValue.replacingOccurrences(of: ",", with: ".")

        guard let doubleValue = Double(stringValue) else {
            return toString(doubleValue: value)
        }
        if doubleValue > validateSettings.max {
            stringValue = rollbackValue()

        } else if doubleValue < validateSettings.min {
            stringValue = rollbackValue()
        } else {
            value = doubleValue
        }

        let hasPoint = stringValue.contains(".")
        if hasPoint {
            let parts = stringValue.split(separator: ".").map { String($0) }
            if parts.count == 2, let number = parts.first, let tail = parts.last, !tail.isEmpty {
                let tail = String(tail.prefix(validateSettings.tail))
                stringValue =  [number, tail].joined(separator: ".")
            }
        }
        return stringValue
    }
}

private extension Double {
    var stringValueWithCutTail: String {
        let result = "\(self)"
        let parts = result.split(separator: ".")
        guard   parts.count == 2,
                let number = parts.first,
                var tail = parts.last else {
            return result
        }

        while !tail.isEmpty {
            if tail.last != "0" { break }
            tail.removeLast()
        }
        return tail.isEmpty ? String(number): [number, tail].joined(separator: ".")
    }
}
