//
//  WeightFrequency.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import Foundation

enum WeightFrequency: String, CaseIterable, Hashable, CustomStringConvertible, Codable {
    case everyDay
    case everyTwoDays
    case everyThreeDays
    case everySevenDays
    case everyFourteenDays

    var description: String {
        NSLocalizedString("WeightFrequency.\(rawValue)", comment: "")
    }

    var days: Int {
        switch self {
        case .everyDay: return 1
        case .everyTwoDays: return 2
        case .everyThreeDays: return 3
        case .everySevenDays: return 7
        case .everyFourteenDays: return 14
        }
    }
}
