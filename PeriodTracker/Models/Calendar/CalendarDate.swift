//
//  CalendarDate.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 04.09.2024.
//

import Foundation
/// типа календарной даты
enum CalendarDayType: Int, Codable {
    /// начало периода
    case startPeriod
}

/// помеченная дата(день) в календаре
struct MenstrualCycleCalendar: Codable {
    let type: CalendarDayType
    let dayDate: Date
}

struct MenstrualCycleParameters {
    let fullCycleLength: Int
    let menstruationPhaseLength: Int
    let follicularPhaseLength: Int
    
}
