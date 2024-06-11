//
//  CustomTextField.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 15.05.2024.
//

import SwiftUI
import AppStudioStyles

struct CustomTextFieldSettings {
    let titleColor: Color
    let units: String?
}

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var value: String
    let settings: CustomTextFieldSettings
    let isKeyboardFocused: Bool?
    let onValidateValue: (String) -> String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: .verticalSpacing) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(settings.titleColor)
                .frame(height: .titleHeight)
                .padding(.horizontal, .titleHorizontalPadding)

            HStack(spacing: .horizontalSpacing) {
                ContentWidthTextField(text: $value, placeholder: placeholder)
                    .font(.poppins(.body))
                    .foregroundStyle(Color.studioBlackLight)
                    .focused($isFocused)
                    .onChange(of: value) { newValue in
                        value = onValidateValue(newValue)
                    }

                if !formattedPlaceholder.isEmpty {
                    Text(formattedPlaceholder)
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioGreyPlaceholder)
                }
                Spacer()
            }
            .padding(.vertical, .verticalPadding)
            .padding(.leading, .leadingPadding)
            .background(Color.studioGreyFillProgress)
            .frame(height: .textfieldHeight)
            .onTapGesture {
                isFocused = true
            }
            .continiousCornerRadius(.cornerRadius)
        }
        .onAppear {
            if let isKeyboardFocused, isKeyboardFocused {
                isFocused = true
            }
        }
        .onChange(of: isKeyboardFocused) { isKeyboardFocused in
            isFocused = isKeyboardFocused == true
        }
    }

    var formattedPlaceholder: String {
        settings.units ?? ""
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 100
    static let textfieldHeight: CGFloat = 48

    static let verticalPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 16
    static let horizontalSpacing: CGFloat = 4
    static let verticalSpacing: CGFloat = 8
    static let titleHeight: CGFloat = 16
    static let titleHorizontalPadding: CGFloat = 16
}
