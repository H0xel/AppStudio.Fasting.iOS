//  
//  MenstrualCycleStorage.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//
import Foundation

protocol MenstrualCycleStorage {
    func allCycles() async throws -> [MenstrualCycle]
    func resetMenstrualDates() async throws
    func menstrualCycles() async throws -> [MenstrualCycle]
    func predictedMenstrualCycles() async throws -> [MenstrualCycle]
}
