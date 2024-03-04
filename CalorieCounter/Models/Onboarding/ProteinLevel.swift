//
//  ProteinLevel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 29.12.2023.
//

import Foundation

enum ProteinLevel: String, CaseIterable, Identifiable, Codable {
    case low
    case moderate
    case high
    case extraHigh

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("ProteinLevel.\(rawValue)", comment: "")
    }

    var descriptionTitle: String {
        NSLocalizedString("ProteinLevel.\(rawValue).description", comment: "")
    }

    var analyticsValue: String {
        switch self {
        case .low: "low"
        case .moderate: "moderate"
        case .high: "high"
        case .extraHigh: "extra_high"
        }
    }
}
