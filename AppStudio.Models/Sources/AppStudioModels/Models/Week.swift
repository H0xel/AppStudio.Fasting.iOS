//
//  Week.swift
//
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation
import AppStudioFoundation

public struct Week: Hashable {
    public let days: [Date]

    public init(ofDay day: Date) {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                          from: day)
        ) else {
            fatalError("Can't get start of Week")
        }
        var daysOfWeek: [Date] = []
        for dayNumber in 0 ... 6 {
            if let day = calendar.date(byAdding: .day, value: dayNumber, to: startOfWeek)?.startOfTheDay {
                daysOfWeek.append(day)
            }
        }
        days = daysOfWeek
    }
}

public extension Week {
    static var current: Week {
        .init(ofDay: .now)
    }

    var previous: Week {
        guard let date = days.first else {
            fatalError("Week can't be empty")
        }
        let prevWeekDay = date.adding(.day, value: -1)
        return .init(ofDay: prevWeekDay)
    }

    var next: Week {
        guard let date = days.last else {
            fatalError("Week can't be empty")
        }
        let nextWeekDay = date.adding(.day, value: 1)
        return .init(ofDay: nextWeekDay)
    }

    func contains(_ day: Date) -> Bool {
        days.contains(day)
    }
}

extension Week: Comparable {
    public static func < (lhs: Week, rhs: Week) -> Bool {
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
