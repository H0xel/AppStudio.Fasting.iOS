//
//  UpdateWeightTextField.swift
//
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import SwiftUI
public enum UpdateWeightTextfieldType {
    case double(maxTail: Int?)
    case integer
}

public struct UpdateWeightTextField: View {

    @Binding var weight: Double
    let units: String
    let type: UpdateWeightTextfieldType
    @State private var weightText = ""
    @FocusState private var isFocused: Bool

    public init(weight: Binding<Double>,
                units: String,
                type: UpdateWeightTextfieldType = .double(maxTail: nil),
                weightText: String = "") {
        self._weight = weight
        self.units = units
        self.weightText = weightText
        self.type = type
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: .spacing) {
            ContentWidthTextField(text: $weightText, placeholder: "0")
                .focused($isFocused)
                .font(.poppins(.accentS))
                .foregroundStyle(Color.studioBlackLight)
            Text(units)
                .font(.poppins(.headerM))
                .foregroundStyle(Color.studioGreyPlaceholder)
                .offset(y: .unitsOffset)
        }
        .onAppear {
            isFocused = true
            weightText = weightText(weight: weight)
        }
        .onChange(of: weight) { newWeight in
            weightText = weightText(weight: newWeight)
        }
        .modifier(DecimalTextFieldModifier(text: $weightText,
                                           decimalValue: $weight))
    }

    private func weightText(weight: Double) -> String {
        guard weight > 0 else {
            return ""
        }
        switch type {
        case .double(let tail):
            var stringValue = "\(weight)"
            if stringValue.hasSuffix(".0") {
                stringValue.removeLast(2)
            }
            if let tail {
                var parts = stringValue.split(separator: ".")
                if parts.count == 2 {
                    parts[1] = parts[1].prefix(tail)
                    stringValue = parts.joined(separator: ".")
                }
            }
            return stringValue

        case .integer:
            return "\(Int(weight))"
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let unitsOffset: CGFloat = -5
}

#Preview {
    UpdateWeightTextField(weight: .constant(20), units: "kg")
}
