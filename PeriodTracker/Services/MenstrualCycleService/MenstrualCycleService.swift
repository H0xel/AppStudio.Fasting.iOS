//  
//  MenstrualCycleService.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//

protocol MenstrualCycleService {
    func calculateCycles() async throws -> [MenstrualCycle]
    func predictCyclesInFuture(from existedCycles: [MenstrualCycle]) async throws -> [MenstrualCycle]
}
