//
//  MenstrualCycleCalendar.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//

import Foundation
/// помеченная дата(день) в календаре
struct MenstrualCycleCalendar: Codable {
    let id: String
    let type: CalendarDayType
    let dayDate: Date

    init(id: String? = nil, type: CalendarDayType, date: Date) {
        self.id = id ?? UUID().uuidString
        self.type = type
        self.dayDate = date.dayDate
    }
}

extension Date {
    var dayDate: Date {
        Calendar.current.dateComponents([.year, .month, .day], from: self).date ?? self
    }
}
