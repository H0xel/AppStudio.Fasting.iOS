//
//  LogType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.05.2024.
//

import SwiftUI

enum LogType: String {
    case log
    case history
    case quickAdd
    case addRecipe
    case newFood
    case food
}

extension LogType {
    var selectedColor: Color {
        switch self {
        case .log, .quickAdd, .addRecipe, .newFood:
                .studioBlackLight
        case .history: 
                .studioGreen
        case .food: 
                .studioOrange
        }
    }

    var image: Image? {
        switch self {
        case .log, .quickAdd, .addRecipe, .newFood:
            nil
        case .history: 
                .logHistory
        case .food: 
                .init(.customProductIcon)
        }
    }

    var title: String {
        "LogType.\(rawValue)".localized()
    }

    var hasSeparator: Bool {
        self == .food
    }
}
