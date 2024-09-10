//  
//  MenstrualCalendarServiceImpl.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//
import Dependencies
import Foundation

class MenstrualCalendarServiceImpl: MenstrualCalendarService {
    @Dependency(\.menstrualCycleCalendarRepository) private var menstrualCycleCalendarRepository

    func dates() async throws -> [Date] {
        try await menstrualCycleCalendarRepository.dates(type: .menstruationDay).map { $0.dayDate }
    }

    func set(dates: [Date]) async throws {
        try await menstrualCycleCalendarRepository.set(dates: dates, type: .menstruationDay)
    }

    func clear(dates: [Date]) async throws {
        try await menstrualCycleCalendarRepository.clear(dates: dates, type: .menstruationDay)
    }

    func clearAll() async throws {
        try await menstrualCycleCalendarRepository.clearAll(type: .menstruationDay)
    }
}
