//
//  CustomKeyboardStyle.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.06.2024.
//

import Foundation

enum CustomKeyboardStyle {
    case container
    case logProduct

    var rightButtons: [CustomKeyboardButton] {
        switch self {
        case .container: [.delete, .up, .down, .done]
        case .logProduct: [.delete, .slash, .log, .add]
        }
    }

    var bottomLeftButton: CustomKeyboardButton {
        switch self {
        case .container: .dot
        case .logProduct: .dot
        }
    }

    var bottomRightButton: CustomKeyboardButton {
        switch self {
        case .container: .slash
        case .logProduct: .collapse
        }
    }
}
