//
//  FastingPlan.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

enum FastingPlan {
    case regular
    case beginner
    case expert

    var duration: TimeInterval {
        switch self {
        case .regular:
            return .hour * 16
        case .beginner:
            return .hour * 14
        case .expert:
            return .hour * 20
        }
    }

    var description: String {
        switch self {
        case .regular:
            return "16:8"
        case .beginner:
            return "14:10"
        case .expert:
            return "20:4"
        }
    }
}
