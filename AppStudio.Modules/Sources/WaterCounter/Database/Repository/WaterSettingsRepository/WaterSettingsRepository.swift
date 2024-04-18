//  
//  WaterSettingsRepositoryService.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//
import Foundation

protocol WaterSettingsRepository {
    func settings() async throws -> WaterSettings?
    func set(settings: WaterSettings) async throws -> WaterSettings
}
