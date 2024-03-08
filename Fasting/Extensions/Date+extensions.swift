//
//  Date+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
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
}
