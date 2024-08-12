//
//  CustomKeyboardButtonType.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

enum CustomKeyboardButton: Hashable {
    case delete
    case up
    case down
    case done
    case dot
    case slash
    case collapse
    case log
    case add
    case number

    var text: String? {
        switch self {
        case .delete: nil
        case .up: nil
        case .down: nil
        case .done: "FoodLogScreen.done".localized()
        case .dot: "."
        case .slash: "/"
        case .collapse: nil
        case .log: "FoodLogScreen.log".localized()
        case .add: "MealTypeView.add".localized()
        case .number: nil
        }
    }

    var image: Image? {
        switch self {
        case .delete: .delete
        case .up: .chevronUp
        case .down: .chevronDown
        case .done: nil
        case .dot: nil
        case .slash: nil
        case .collapse: .keyboardDown
        case .log: nil
        case .add: nil
        case .number: nil
        }
    }
}
