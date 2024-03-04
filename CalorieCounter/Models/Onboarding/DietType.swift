//
//  DietType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 29.12.2023.
//

import Foundation

enum DietType: String, CaseIterable, Identifiable, Codable {
    case balanced
    case lowFat
    case lowCarb
    case keto

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("DietType.\(rawValue)", comment: "")
    }

    var descriptionTitle: String {
        NSLocalizedString("DietType.\(rawValue).description", comment: "")
    }

    var partOfCarb: Double {
        switch self {
        case .balanced:
            0.66
        case .lowFat:
            0.8
        case .lowCarb:
            0.3
        case .keto:
            0.07
        }
    }

    var analyticsValue: String {
        switch self {
        case .balanced: "balanced"
        case .lowFat: "low_fat"
        case .lowCarb: "low_carb"
        case .keto: "keto"
        }
    }
}
