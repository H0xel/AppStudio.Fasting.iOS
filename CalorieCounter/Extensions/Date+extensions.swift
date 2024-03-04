//
//  Date+extensions.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import Foundation

extension Date {
    var daysOfWeek: [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.date(
            from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        ) else {
            return []
        }
        var daysOfWeek: [Date] = []
        for dayNumber in 1 ... 7 {
            if let day = calendar.date(byAdding: .day, value: dayNumber, to: startOfWeek)?.beginningOfDay {
                daysOfWeek.append(day)
            }
        }
        return daysOfWeek
    }

    var weekdayLetter: String {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        switch components.weekday {
        case 1: return NSLocalizedString("Weekday.sunday", comment: "S")
        case 2: return NSLocalizedString("Weekday.monday", comment: "M")
        case 3: return NSLocalizedString("Weekday.tuesday", comment: "T")
        case 4: return NSLocalizedString("Weekday.wednesday", comment: "W")
        case 5: return NSLocalizedString("Weekday.thursday", comment: "T")
        case 6: return NSLocalizedString("Weekday.friday", comment: "F")
        case 7: return NSLocalizedString("Weekday.saturday", comment: "S")

        default: return ""
        }
    }
}
