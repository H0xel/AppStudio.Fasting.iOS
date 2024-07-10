//
//  CustomKeyboardTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import SwiftUI

struct CustomKeyboardTextField: View {

    @Binding var isTextSelected: Bool
    let title: String
    let text: String
    let units: String
    let grammsValue: String?

    var body: some View {
        VStack(spacing: .verticalSpacing) {
            Text(title)
                .foregroundStyle(Color.studioGreyText)
                .font(.poppins(.description))
                .padding(.leading, .titleLeadingPadding)
                .aligned(.left)
            CustomKeyboardTextView(isTextSelected: $isTextSelected,
                                   text: text,
                                   units: units,
                                   grammsValue: grammsValue)
        }
        .padding(.padding)
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
    }
}

private extension CGFloat {
    static let padding: CGFloat = 10
    static let verticalSpacing: CGFloat = 8
    static let titleLeadingPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
}

#Preview {
    CustomKeyboardTextField(isTextSelected: .constant(false),
                            title: "Eggs",
                            text: "",
                            units: "g",
                            grammsValue: nil)
}