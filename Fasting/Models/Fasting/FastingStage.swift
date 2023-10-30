//
//  FastingStage.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import SwiftUI

enum FastingStage: String, CaseIterable, Equatable {
    case sugarRises
    case sugarDrop
    case sugarNormal
    case burning
    case ketosis
    case autophagy

    var backgroundColor: Color {
        switch self {
        case .autophagy:
            return .fastingBlueLight
        case .burning:
            return .fastingOrange
        case .ketosis:
            return .fastingGreen
        case .sugarDrop:
            return .fastingPurple
        case .sugarNormal:
            return .fastingRed
        case .sugarRises:
            return .fastingBlue
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .sugarRises:
            return "FastingStage.bloodSugarRises"
        case .sugarDrop:
            return "FastingStage.bloodSugarFalls"
        case .sugarNormal:
            return "FastingStage.bloodSugarNormal"
        case .burning:
            return "FastingStage.burningFat"
        case .ketosis:
            return "FastingStage.ketosis"
        case .autophagy:
            return "FastingStage.autophagy"
        }
    }

    var whiteImage: Image {
        Image("\(rawValue)White")
    }

    var disabledImage: Image {
        Image("\(rawValue)Disabled")
    }

    var coloredImage: Image {
        Image("\(rawValue)Enabled")
    }

    static func > (lhs: FastingStage, rhs: FastingStage) -> Bool {
        guard let leftIndex = FastingStage.allCases.firstIndex(of: lhs),
              let rightIndex = FastingStage.allCases.firstIndex(of: rhs) else {
                  return true
              }
        return leftIndex > rightIndex
    }
}
