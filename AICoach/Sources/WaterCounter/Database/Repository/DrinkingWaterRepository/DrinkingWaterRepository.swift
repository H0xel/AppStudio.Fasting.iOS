//  
//  DrinkingWaterService.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//
import Foundation

protocol DrinkingWaterRepository {
    func save(water: DrinkingWater) async throws
    func get(waterId: String) async throws -> DrinkingWater?
    func water(from: Date, to: Date) async throws -> [DrinkingWater]
    func remove(water: DrinkingWater) async throws
    func waterObserver(for date: Date) -> DrinkingWaterObserver    
}
