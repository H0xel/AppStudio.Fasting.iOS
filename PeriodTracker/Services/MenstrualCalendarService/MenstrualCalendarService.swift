//  
//  MenstrualCalendarService.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//
import Foundation

protocol MenstrualCalendarService {
    func dates() async throws -> [Date]
    func set(dates: [Date]) async throws
    func clear(dates: [Date]) async throws
    func clearAll() async throws
}
