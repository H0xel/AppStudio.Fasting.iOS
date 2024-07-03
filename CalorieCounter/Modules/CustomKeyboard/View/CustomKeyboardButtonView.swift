//
//  CustomKeyboardButtonView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import SwiftUI
import AudioToolbox

struct CustomKeyboardButtonView: View {

    let button: CustomKeyboardButton
    let isAccent: Bool
    let action: (CustomKeyboardButton) -> Void

    var body: some View {
        Button {
            AudioServicesPlaySystemSound(soundID)
            action(button)
        } label: {
            Group {
                if let image = button.image {
                    image
                } else if let text = button.text {
                    Text(text)
                }
            }
            .font(font)
            .foregroundStyle(isAccent ? .white : .black)
            .modifier(CustomKeyboardButtonModifier(backgroundColor: .studioBlackLight.opacity(isAccent ? 1 : 0.15)))
        }
    }

    private var font: Font {
        switch button {
        case .delete, .up, .down, .done, .collapse, .add, .log:
                .poppinsMedium(.body)
        case .dot:
                .poppinsBold(.buttonText)
        case .slash:
                .poppins(.buttonText)
        }
    }

    var soundID: SystemSoundID {
        switch button {
        case .delete:
            1155
        case .up, .down, .done, .collapse, .log,.add:
            1156
        case .dot, .slash:
            1104
        }
    }
}

#Preview {
    CustomKeyboardButtonView(button: .slash, isAccent: false) { _ in }
}
