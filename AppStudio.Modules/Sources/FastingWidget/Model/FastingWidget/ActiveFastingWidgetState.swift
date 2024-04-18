//
//  ActiveFastingWidgetState.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

public protocol FastingWidgetPhase {
    var title: String { get }
    var backgroundColor: Color { get }
    var timeRange: ClosedRange<TimeInterval> { get }
    var whiteImage: Image { get }
    var coloredImage: Image { get }
}

public struct ActiveFastingWidgetState {
    let startDate: Date
    let finishDate: Date
    let phases: [FastingWidgetPhase]
    let onEndFastingTap: () -> Void
    let onSettingsTap: () -> Void
    let onCircleTap: () -> Void

    public init(startDate: Date,
                finishDate: Date,
                phases: [FastingWidgetPhase],
                onEndFastingTap: @escaping () -> Void,
                onSettingsTap: @escaping () -> Void,
                onCircleTap: @escaping () -> Void) {
        self.startDate = startDate
        self.finishDate = finishDate
        self.phases = phases
        self.onEndFastingTap = onEndFastingTap
        self.onSettingsTap = onSettingsTap
        self.onCircleTap = onCircleTap
    }
}

extension ActiveFastingWidgetState {
    static var mock: ActiveFastingWidgetState {
        .init(startDate: .now.adding(.hour, value: -20),
              finishDate: .now.adding(.hour, value: -1),
              phases: FastingStage.allCases,
              onEndFastingTap: {},
              onSettingsTap: {}, 
              onCircleTap: { })
    }
}

extension FinishedFastingWidgetState {
    static var mockFinished: FinishedFastingWidgetState {
        .init(fastingId: "",
              startDate: .now.adding(.hour, value: -16),
              finishedDate: .now,
              finishPhase: FastingStage.autophagy)
    }

    static var mockEmpty: FinishedFastingWidgetState {
        .init(fastingId: "",
              startDate: .now,
              finishedDate: .now,
              finishPhase: FastingStage.sugarRises)
    }
}

private enum FastingStage: String, CaseIterable, Equatable, FastingWidgetPhase {
    case sugarRises
    case sugarDrop
    case sugarNormal
    case burning
    case ketosis
    case autophagy

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
        Image("\(rawValue)White", bundle: .main)
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
