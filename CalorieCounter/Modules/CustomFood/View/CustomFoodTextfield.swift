//
//  CustomFoodTextfield.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI

struct CustomFoodTextfield: View {
    @Binding var selectedField: CustomFoodField
    @Binding var text: String
    let configuration: Configuration
    @FocusState private var focusField: CustomFoodField?

    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: .spacing) {
                Text(configuration.type.keyboardTitle)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyText)
                TextField(configuration.textFieldPlaceholder, text: $text)
                    .font(configuration.font)
                    .submitLabel(.next)
                    .tint(Color.studioBlackLight)
                    .focused($focusField, equals: configuration.type)
                    .onSubmit {
                        selectedField = selectedField.next()
                    }
            }
            Spacer()
        }
        .padding()
        .background()
        .continiousCornerRadius(.cornerRadius)
        .border(configuration: focusField == configuration.type ? .focused : .empty)
        .padding(.horizontal, .horizontalPadding)
        .onChange(of: focusField) { field in
            if let field {
                selectedField = field
            }
        }
        .onChange(of: selectedField) { output in
            if output.keyboardType == .text {
                focusField = output
            } else {
                focusField = nil
                hideKeyboard()
            }
        }
    }
}

extension CustomFoodTextfield {
    struct Configuration {
        let type: CustomFoodField
        let textFieldPlaceholder: LocalizedStringKey
        let font: Font
    }
}

extension CustomFoodTextfield.Configuration {
    static var foodName: CustomFoodTextfield.Configuration {
        .init(
            type: .foodName,
            textFieldPlaceholder: "CustomFood.textfield.foodName",
            font: .poppins(.headerS)
        )
    }

    static var brandName: CustomFoodTextfield.Configuration {
        .init(
            type: .brandName,
            textFieldPlaceholder: "CustomFood.textfield.optional",
            font: .poppins(.body)
        )
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
    static let cornerRadius: CGFloat = 20
    static let horizontalPadding: CGFloat = 20
}

#Preview {
    CustomFoodTextfield(selectedField: .constant(.none), text: .constant(""), configuration: .foodName)
}
