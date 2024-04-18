//
//  FastingHistoryStage.swift
//
//
//  Created by Amakhin Ivan on 22.03.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioStyles

public extension FastingHistoryStage {
    var backgroundColor: Color {
        switch self {
        case .autophagy:
            return .studioSky
        case .burning:
            return .studioOrange
        case .ketosis:
            return .studioGreen
        case .sugarDrop:
            return .studioPurple
        case .sugarNormal:
            return .studioRed
        case .sugarRises:
            return .studioBlue
        case .water:
            return .studioSky
        }
    }

    var image: Image {
        switch self {
        case .autophagy:
            return .autophagy
        case .burning:
            return .burning
        case .ketosis:
            return .ketosis
        case .sugarDrop:
            return .sugarDrop
        case .sugarNormal:
            return .sugarNormal
        case .sugarRises:
            return .sugarRises
        case .water:
            return .autophagy
        }
    }

    var title: String {
        switch self {
        case .sugarRises:
            return NSLocalizedString("FastingHistoryScreen.bloodSugarRises", bundle: .module, comment: "")
        case .sugarDrop:
            return NSLocalizedString("FastingHistoryScreen.bloodSugarFalls", bundle: .module, comment: "")
        case .sugarNormal:
            return NSLocalizedString("FastingHistoryScreen.bloodSugarNormal", bundle: .module, comment: "")
        case .burning:
            return NSLocalizedString("FastingHistoryScreen.burningFat", bundle: .module, comment: "")
        case .ketosis:
            return NSLocalizedString("FastingHistoryScreen.ketosis", bundle: .module, comment: "")
        case .autophagy:
            return NSLocalizedString("FastingHistoryScreen.autophagy", bundle: .module, comment: "")
        case .water:
            return ""
        }
    }

    var stageWeight: Int {
        switch self {
        case .sugarRises: return 2
        case .sugarDrop: return 8
        case .sugarNormal: return 10
        case .burning: return 14
        case .ketosis: return 16
        case .autophagy: return 20
        case .water: return 0
        }
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
        case .water:
            return hoursRange(from: 0, to: 0)
        }
    }

    func hoursRange(from: Double, to hoursTo: Double) -> ClosedRange<TimeInterval> {
        (.hour * from) ... (.hour * hoursTo)
    }

}

extension FastingHistoryStage: Comparable {
    public static func < (lhs: FastingHistoryStage, rhs: FastingHistoryStage) -> Bool {
        guard let leftIndex = FastingHistoryStage.allCases.firstIndex(of: lhs),
              let rightIndex = FastingHistoryStage.allCases.firstIndex(of: rhs) else {
                  return true
              }
        return leftIndex < rightIndex
    }
}
