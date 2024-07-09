//
//  HydrationFrequency.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import Foundation

enum HydrationFrequency: String, CaseIterable, Hashable, CustomStringConvertible, Codable {
    case everyHour
    case everyTwoHours
    case everyThreeHours
    case everyFourHours
    case everyFiveHours
    case everySixHours

    var description: String {
        NSLocalizedString("HydrationFrequency.\(rawValue)", comment: "")
    }

    var hours: Int {
        switch self {
        case .everyHour: return 1
        case .everyTwoHours: return 2
        case .everyThreeHours: return 3
        case .everyFourHours: return 4
        case .everyFiveHours: return 5
        case .everySixHours: return 6
        }
    }
}
