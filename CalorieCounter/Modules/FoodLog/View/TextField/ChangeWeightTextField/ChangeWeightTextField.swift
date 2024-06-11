//
//  ChangeWeightTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 27.12.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles

struct ChangeWeightTextField: View {

    let title: String
    let initialWeight: Double
    let onWeightChange: (Double) -> Void
    let onCancel: () -> Void

    @State private var text: String = ""
    @State private var weight: Double = 0
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .center, spacing: .spacing) {
            VStack(spacing: .spacing) {
                Text(title)
                    .foregroundStyle(Color.studioGreyText)
                    .font(.poppins(.description))
                    .lineLimit(1)
                    .aligned(.left)
                TextField("",
                          text: $text,
                          prompt: Text("0"))
                .withSelectedTextInTextField
                .focused($isFocused)
                .submitLabel(.done)
                .font(.poppins(.body))
            }
            .padding(.vertical, .verticalPadding)

            if !text.isEmpty {
                ChangeWeightButton {
                    hideKeyboard()
                    onWeightChange(weight)
                }
            }
        }
        .foregroundStyle(.accent)
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
        .onAppear {
            text = "\(Int(initialWeight))"
            weight = initialWeight
            isFocused = true
        }
        .onChange(of: initialWeight) { initialWeight in
            text = "\(Int(initialWeight))"
            weight = initialWeight
        }
        .onChange(of: isFocused) { isFocused in
            guard !isFocused else {
                return
            }
            chageWeight()
        }
        .modifier(DecimalTextFieldModifier(text: $text, decimalValue: $weight))
        .modifier(TopBorderModifier())
        .aligned(.bottom)
    }

    private func chageWeight() {
        if !text.isEmpty {
            onWeightChange(weight)
        } else {
            onCancel()
        }
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 20
    static let leadingPadding: CGFloat = 24
    static let trailingPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let spacing: CGFloat = 8
    static let arrowBottomPadding: CGFloat = 14
    static let borderWidth: CGFloat = 0.5
}
