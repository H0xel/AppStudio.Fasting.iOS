//  
//  MenstrualCycleCalendarRepository.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//
import Foundation

protocol MenstrualCycleCalendarRepository {
    func dates(type: CalendarDayType) async throws -> [MenstrualCycleCalendar]
    func set(dates: [Date], type: CalendarDayType) async throws
    func clear(dates: [Date], type: CalendarDayType) async throws
    func clearAll(type: CalendarDayType) async throws
    func exists(date: Date, type: CalendarDayType) async throws -> MenstrualCycleCalendar?
}
