//
//  FastingGoal.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

enum FastingGoal: String, CaseIterable, Identifiable, Codable {
    case loseWeight
    case lookBetter
    case feelMoreEnergetic
    case improveMentalClarity
    case liveLonger
    case healthierLifestyle

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("FastingGoal.\(rawValue)", comment: "")
    }

    var bullet: String {
        NSLocalizedString("FastingGoal.bullet.\(rawValue)", comment: "")
    }

    static var availableBullets: [FastingGoal: String] = {
        FastingGoal.allCases
            .filter { $0 != .loseWeight }
            .reduce(into: [FastingGoal: String]()) { partialResult, goal in
                partialResult[goal] = goal.bullet
            }
    }()
}
