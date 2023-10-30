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
}
