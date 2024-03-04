//
//  ActivityType.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 29.12.2023.
//

import Foundation

enum ActivityType: String, CaseIterable, Identifiable, Codable {
    case noActivity
    case lifting
    case cardio
    case both

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("ActivityType.\(rawValue)", comment: "")
    }

    var analyticsValue: String {
        switch self {
        case .noActivity: "none"
        case .lifting: "lifting"
        case .cardio: "cardio"
        case .both: "cardio_lifting"
        }
    }
}
