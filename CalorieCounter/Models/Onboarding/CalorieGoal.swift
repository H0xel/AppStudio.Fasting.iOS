//
//  CalorieGoal.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import Foundation

enum CalorieGoal: String, CaseIterable, Identifiable, Codable {
    case lose
    case maintain
    case gain

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("CalorieGoal.\(rawValue)", comment: "")
    }

    var descriptionTitle: String {
        NSLocalizedString("CalorieGoal.\(rawValue).description", comment: "")
    }

    var maxPercentRange: ClosedRange<Double> {
        switch self {
        case .lose: .init(uncheckedBounds: (lower: 0.001, upper: 0.015))
        case .maintain: .init(uncheckedBounds: (lower: 0.0, upper: 0.0))
        case .gain: .init(uncheckedBounds: (lower: 0.0003, upper: 0.005))
        }
    }

    var recomendedPercentRange: ClosedRange<Double> {
        switch self {
        case .lose: .init(uncheckedBounds: (lower: 0.003, upper: 0.01))
        case .maintain: .init(uncheckedBounds: (lower: 0.0, upper: 0.0))
        case .gain: .init(uncheckedBounds: (lower: 0.001, upper: 0.0025))
        }
    }

    var startingPointPercent: Double {
        switch self {
        case .lose: 0.005
        case .maintain: 0
        case .gain: 0.002
        }
    }
}
