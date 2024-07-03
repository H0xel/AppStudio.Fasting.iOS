//
//  CustomKeyboardStyle.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import Foundation

enum CustomKeyboardStyle {
    case container

    var rightButtons: [CustomKeyboardButton] {
        switch self {
        case .container: [.delete, .up, .down, .done]
        }
    }

    var bottomLeftButton: CustomKeyboardButton {
        switch self {
        case .container: .dot
        }
    }

    var bottomRightButton: CustomKeyboardButton {
        switch self {
        case .container: .slash
        }
    }
}
