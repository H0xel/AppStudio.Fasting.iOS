//
//  Week.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 24.01.2024.
//

import Foundation

struct Week: Hashable {
    let days: [Date]
}

extension Week {
    var previous: Week {
        guard let date = days.first else {
            return .init(days: [])
        }
        return .init(days: date.adding(.day, value: -1).daysOfWeek)
    }

    var next: Week {
        guard let date = days.last else {
            return .init(days: [])
        }
        return .init(days: date.adding(.day, value: 1).daysOfWeek)
    }
}

extension Week: Comparable {
    static func < (lhs: Week, rhs: Week) -> Bool {
        if lhs.days == rhs.days {
            return false
        }
        guard let lhsDay = lhs.days.first,
              let rhsDay = rhs.days.first else {
            return false
        }
        return lhsDay < rhsDay
    }
}
