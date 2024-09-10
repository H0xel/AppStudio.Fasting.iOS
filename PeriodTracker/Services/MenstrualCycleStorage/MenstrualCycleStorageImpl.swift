//  
//  MenstrualCycleStorageImpl.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 09.09.2024.
//
import Foundation
import Dependencies
private let storageKey = "PeriodTracker.MenstrualCycleStorageKey"

class MenstrualCycleStorageImpl: MenstrualCycleStorage {

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.menstrualCycleService) private var menstrualCycleService

    func menstrualCycles() async throws -> [MenstrualCycle] {
        if let storedCycles = await storedCycles {
            return storedCycles
        }
        // calculate menstrual periods and store it
        let cycles = try await menstrualCycleService.calculateCycles()
        await storeCycles(cycles)
        return cycles
    }

    func predictedMenstrualCycles() async throws -> [MenstrualCycle] {
        try await menstrualCycleService.predictCyclesInFuture(from: try await menstrualCycles())
    }

    func resetMenstrualDates() async throws {
        await storeCycles(nil)
    }

    func allCycles() async throws -> [MenstrualCycle] {
        let cycles = try await menstrualCycles()
        guard !cycles.isEmpty else {
            return []
        }

        let predicted = try await predictedMenstrualCycles()
        return cycles + predicted
    }
}

extension MenstrualCycleStorageImpl {
    @MainActor
    private func storeCycles(_ cycles: [MenstrualCycle]?) {
        storedCycles = cycles
    }

    @MainActor
    private var storedCycles: [MenstrualCycle]? {
        get {
            cloudStorage.get(key: storageKey)
        }

        set {
            cloudStorage.set(key: storageKey, value: newValue)
        }
    }
}
