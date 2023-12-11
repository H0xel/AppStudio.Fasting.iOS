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
            return .fastingSky
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

    var title: String {
        switch self {
        case .sugarRises:
            return NSLocalizedString("FastingStage.bloodSugarRises", comment: "")
        case .sugarDrop:
            return NSLocalizedString("FastingStage.bloodSugarFalls", comment: "")
        case .sugarNormal:
            return NSLocalizedString("FastingStage.bloodSugarNormal", comment: "")
        case .burning:
            return NSLocalizedString("FastingStage.burningFat", comment: "")
        case .ketosis:
            return NSLocalizedString("FastingStage.ketosis", comment: "")
        case .autophagy:
            return NSLocalizedString("FastingStage.autophagy", comment: "")
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

    var timeRange: ClosedRange<TimeInterval> {
        switch self {
        case .sugarRises:
            return hoursRange(from: 0, to: 2)
        case .sugarDrop:
            return hoursRange(from: 2, to: 8)
        case .sugarNormal:
            return hoursRange(from: 8, to: 10)
        case .burning:
            return hoursRange(from: 10, to: 14)
        case .ketosis:
            return hoursRange(from: 14, to: 16)
        case .autophagy:
            return hoursRange(from: 16, to: .infinity)
        }
    }

    var startHour: Double {
        timeRange.lowerBound
    }

    func hoursRange(from: Double, to hoursTo: Double) -> ClosedRange<TimeInterval> {
        (.hour * from) ... (.hour * hoursTo)
    }

    static var withoutAutophagy: [FastingStage] {
        FastingStage.allCases.filter { $0 != .autophagy }
    }
}

extension FastingStage: Comparable {
    static func < (lhs: FastingStage, rhs: FastingStage) -> Bool {
        guard let leftIndex = FastingStage.allCases.firstIndex(of: lhs),
              let rightIndex = FastingStage.allCases.firstIndex(of: rhs) else {
                  return true
              }
        return leftIndex < rightIndex
    }
}
