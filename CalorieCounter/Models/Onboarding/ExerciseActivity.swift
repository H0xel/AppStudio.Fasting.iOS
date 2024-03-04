//
//  ExerciseActivity.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 28.12.2023.
//

import Foundation

enum ExerciseActivity: String, CaseIterable, Identifiable, Codable {
    case sessionsPerWeek0
    case sessionsPerWeek1to3
    case sessionsPerWeek4to6
    case sessionsPerWeekMoreThan7

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("ExerciseActivity.\(rawValue)", comment: "")
    }

    var analitycsValue: String {
        switch self {
        case .sessionsPerWeek0: "0"
        case .sessionsPerWeek1to3: "1_3"
        case .sessionsPerWeek4to6: "4_6"
        case .sessionsPerWeekMoreThan7: "7+"
        }
    }
}
