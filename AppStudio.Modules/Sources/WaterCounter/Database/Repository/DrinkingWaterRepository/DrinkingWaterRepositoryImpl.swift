//  
//  DrinkingWaterServiceImpl.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import MunicornCoreData
import Dependencies
import CoreData

class DrinkingWaterRepositoryImpl: CoreDataBaseRepository<DrinkingWater>, DrinkingWaterRepository {
    
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func get(waterId: String) async throws -> DrinkingWater? {
        try await object(byId: waterId)
    }

    func save(water: DrinkingWater) async throws {
        _ = try await save(water)
    }

    func water(from: Date, to: Date) async throws -> [DrinkingWater] {
        let request = requestWater(from: from, to: to)
        return try await select(request: request)
    }

    func remove(water: DrinkingWater) async throws {
        try await delete(byId: water.id)
    }

    func remove(from: Date, to: Date) async throws {
        let request = requestWater(from: from, to: to)
        let deleteRequest = DrinkingWater.batchDeleteRequest(fetchRequest: request)
        try await delete(batchDeleteRequest: deleteRequest)
    }

    func waterObserver(for date: Date) -> DrinkingWaterObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = DrinkingWaterObserver(coreDataService: coreDataService)
        let request = requestWater(from: date.startOfTheDay, to: date.endOfDay)
        observer.fetch(request: request)
        return observer
    }

    func waterObserverAll() -> DrinkingWaterObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = DrinkingWaterObserver(coreDataService: coreDataService)
        let request = DrinkingWater.request()
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        observer.fetch(request: request)
        return observer
    }

    private func requestWater(from: Date, to: Date) -> NSFetchRequest<DrinkingWater.EntityType> {
        let request = DrinkingWater.request()
        request.predicate = NSPredicate(format: "date >= %@ and date <= %@", from as NSDate, to as NSDate)
        request.sortDescriptors = [.init(key: "date", ascending: true)]
        return request
    }
}
