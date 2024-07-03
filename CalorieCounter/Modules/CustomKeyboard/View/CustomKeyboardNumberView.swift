//
//  CustomKeyboardNumberView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

struct CustomKeyboardNumberView: View {

    let number: Int

    var body: some View {
        Text("\(number)")
            .font(.poppins(.buttonText))
            .foregroundStyle(Color.studioBlackLight)
            .modifier(CustomKeyboardButtonModifier())
    }
}

#Preview {
    CustomKeyboardNumberView(number: 5)
}
