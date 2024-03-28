//  
//  WaterSettingsRepositoryServiceImpl.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//
import Foundation
import MunicornCoreData
import Dependencies

class WaterSettingsRepositoryImpl: CoreDataBaseRepository<WaterSettings>, WaterSettingsRepository {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func settings() async throws -> WaterSettings? {
        let request = WaterSettings.request()
        request.sortDescriptors = [.init(key: "date", ascending: false)]
        request.fetchLimit = 1
        if let result = try await select(request: request).first {
            return result
        }

        return nil
    }
    
    func set(settings: WaterSettings) async throws -> WaterSettings {
        if var currentSettings = try await get(by: .now) {
            currentSettings.prefferedValue = settings.prefferedValue
            currentSettings.units = settings.units
            return try await self.save(currentSettings)
        }
        return try await self.save(settings)
    }

    func get(by date: Date) async throws -> WaterSettings? {
        let request = WaterSettings.request()
        request.predicate = NSPredicate(format: "date == %@", date.startOfTheDay as NSDate)
        request.fetchLimit = 1

        return try await select(request: request).first
    }
}
