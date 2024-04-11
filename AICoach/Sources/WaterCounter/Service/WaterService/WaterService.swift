//  
//  WaterService.swift
//  
//
//  Created by Denis Khlopin on 15.03.2024.
//
import Foundation

public protocol WaterService {
    func settings() async throws -> WaterSettings
    func save(settings: WaterSettings) async throws -> WaterSettings

    func dailyGoal(for date: Date) async throws -> DailyWaterGoal
    func save(dailyGoal: DailyWaterGoal) async throws -> DailyWaterGoal

    func add(water: DrinkingWater) async throws -> Double
    func waterObserver(for date: Date) -> DrinkingWaterObserver
    func waterObserverAll() -> DrinkingWaterObserver
    func water(for date: Date) async throws -> Double
    func water() async throws -> [Date: DrinkingWater]
    func deleteWater(at date: Date) async throws
    func updateWater(for date: Date, quantity: Double) async throws -> Double
}


class WaterServiceMock: WaterService {
    func deleteWater(at date: Date) async throws {}
    
    func updateWater(for date: Date, quantity: Double) async throws -> Double {
        0
    }
    
    func waterObserverAll() -> DrinkingWaterObserver {
        .init()
    }
    
    func water() async throws -> [Date : DrinkingWater] {
        [:]
    }
    
    func settings() async throws -> WaterSettings {
        .default
    }
    
    func save(settings: WaterSettings) async throws -> WaterSettings { .default }
    
    func dailyGoal(for date: Date) async throws -> DailyWaterGoal {
        .default
    }
    
    func save(dailyGoal: DailyWaterGoal) async throws -> DailyWaterGoal {
        dailyGoal
    }
    
    func add(water: DrinkingWater) async throws -> Double { 0 }

    func waterObserver(for date: Date) -> DrinkingWaterObserver {
        .init()
    }
    
    func water(for date: Date) async throws -> Double {
        777.7
    }
}
