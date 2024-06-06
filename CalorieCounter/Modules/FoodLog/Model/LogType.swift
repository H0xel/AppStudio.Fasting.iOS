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
}

extension LogType {
    var selectedColor: Color {
        switch self {
        case .log, .quickAdd, .addRecipe:
            Color.studioBlackLight
        case .history:
            Color.studioGreen
        }
    }

    var image: Image? {
        switch self {
        case .log, .quickAdd, .addRecipe:
            nil
        case .history:
            .logHistory
        }
    }

    var title: String {
        switch self {
        case .log:
            NSLocalizedString("LogType.log", comment: "Log")
        case .history:
            NSLocalizedString("LogType.history", comment: "History")
        case .quickAdd:
            NSLocalizedString("LogType.quickAdd", comment: "Quick Add")
        case .addRecipe:
            NSLocalizedString("LogType.addRecipe", comment: "Add Recipe")
        }
    }

    var hasSeparator: Bool {
        self == .history
    }
}
