//
//  CalendarDayType.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//

import Foundation
/// типа календарной даты
enum CalendarDayType: Int16, Codable {
    /// день менструации, первый день менструации = начало цикла
    case menstruationDay = 0
}
