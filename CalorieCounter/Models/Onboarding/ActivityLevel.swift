//
//  ActivityLevel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

enum ActivityLevel: String, CaseIterable, Identifiable, Codable {
    case sedentary
    case moderatelyActive
    case veryActive

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("ActivityLevel.\(rawValue)", comment: "")
    }

    var descriptionTitle: String {
        NSLocalizedString("ActivityLevel.\(rawValue).description", comment: "")
    }
}
