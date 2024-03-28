//  
//  WaterServiceImpl.swift
//  
//
//  Created by Denis Khlopin on 15.03.2024.
//
import Foundation
import Dependencies
import AppStudioServices
import MunicornFoundation

class WaterServiceImpl: WaterService {
    @Dependency(\.waterSettingsRepository) private var waterSettingsRepository
    @Dependency(\.drinkingWaterRepository) private var drinkingWaterRepository
    @Dependency(\.dailyWaterGoalRepository) private var dailyWaterGoalRepository
    @Dependency(\.waterIntakeService) private var waterIntakeService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.cloudStorage) private var cloudStorage

    func settings() async throws -> WaterSettings {
        if let settings = try await waterSettingsRepository.settings() {
            return settings
        }

        if let units = waterIntakeService.waterUnits {
            let prefferedValue = units == .ounces ? units.localToValue(value: 8) : units.localToValue(value: 250)
            return WaterSettings(date: .now, prefferedValue: prefferedValue, units: units)
        }

        return .default

    }
    
    func save(settings: WaterSettings) async throws -> WaterSettings {
        try await waterSettingsRepository.set(settings: settings)
    }
    
    func dailyGoal(for date: Date) async throws -> DailyWaterGoal {
        try await dailyWaterGoalRepository.goal(at: date) ?? DailyWaterGoal(quantity: waterIntakeService.waterIntake ?? 2500, date: date)
    }
    
    func save(dailyGoal: DailyWaterGoal) async throws -> DailyWaterGoal {
        try await dailyWaterGoalRepository.set(goal: dailyGoal)
    }
    
    func add(water: DrinkingWater) async throws -> Double {
        guard water.quantity != 0 else {
            return 0
        }
        let total = try await self.water(for: water.date)
        
        if total <= 0, water.quantity > 0 {
            trackWater(date: water.date)
        }

        var water = water
        if water.quantity < 0 {

            if total == 0 {
                return 0
            }

            if total < abs(water.quantity) {
                water.quantity = -total
            }
        }

        if total + water.quantity <= 0 {
            untrackWater(date: water.date)
        }

        try await drinkingWaterRepository.save(water: water)
        return water.quantity
    }
    
    func waterObserver(for date: Date) -> DrinkingWaterObserver {
        drinkingWaterRepository.waterObserver(for: date)
    }

    func water(for date: Date) async throws -> Double {
        try await drinkingWaterRepository.water(from: date.startOfTheDay, to: date.endOfDay)
            .reduce(into: 0.0) { $0 += $1.quantity }
    }

    private func trackWater(date: Date) {
        if cloudStorage.trackedWater[date] == nil {
            userPropertyService.incrementProperty(property: "water_tracked_count", value: 1)
            cloudStorage.trackedWater[date] = true
        }
    }

    private func untrackWater(date: Date) {
        if cloudStorage.trackedWater[date] != nil {
            userPropertyService.decrementProperty(property: "water_tracked_count", value: 1)
            cloudStorage.trackedWater[date] = nil
        }
    }
}

private let trackedWaterKey = "Water.trackedWaterKey"
private extension CloudStorage {
    var trackedWater: [Date: Bool] {
        set {
            set(key: trackedWaterKey, value: newValue.json())
        }

        get {
            let json: String? = get(key: trackedWaterKey)
            return (try? [Date: Bool].init(json: json ?? "")) ?? [:]
        }
    }
}
