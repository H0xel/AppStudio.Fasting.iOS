//
//  MenstrualCycleCalendar+Mapped.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//

import MunicornCoreData

extension MenstrualCycleCalendar: EntityMappable {
    init(entity: MenstrualCycleCalendarEntity) throws {
        self.id = entity.id ?? ""
        self.type = CalendarDayType(rawValue: entity.type) ?? .menstruationDay
        self.dayDate = entity.dayDate ?? .now
    }
    func map(to entity: MenstrualCycleCalendarEntity) {
        entity.id = id
        entity.dayDate = dayDate
        entity.type = type.rawValue
    }

    static var identifierName: String {
        "id"
    }
}
