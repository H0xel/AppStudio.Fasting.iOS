//
//  NutritionProfileRepositoryImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.01.2024.
//

import Foundation
import MunicornCoreData
import Dependencies

class NutritionProfileRepositoryImpl: CoreDataBaseRepository<DatedNutritionProfile> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension NutritionProfileRepositoryImpl: NutritionProfileRepository {

    func nutritionProfile(dayDate: Date) async throws -> DatedNutritionProfile? {
        let request = DatedNutritionProfile.request()
        request.predicate = NSPredicate(format: "startDate <= %@", dayDate.endOfDay as NSDate)
        request.sortDescriptors = [.init(key: "startDate", ascending: false)]
        request.fetchLimit = 1
        let results = try await select(request: request)
        if let result = results.first {
            return result
        }
        return try await firstProfile()
    }

    @discardableResult
    func save(profile: DatedNutritionProfile) async throws -> DatedNutritionProfile {
        try await save(profile)
    }

    func deleteFromSelectedDay(day: Date) async throws {
        let request = DatedNutritionProfile.request()
        request.predicate = .init(format: "startDate >= %@ AND startDate <= %@",
                                  day.beginningOfDay as NSDate,
                                  day.endOfDay as NSDate)
        let deleteRequest = DatedNutritionProfile.batchDeleteRequest(fetchRequest: request)
        try await delete(batchDeleteRequest: deleteRequest)
    }

    private func firstProfile() async throws -> DatedNutritionProfile? {
        let request = DatedNutritionProfile.request()
        request.sortDescriptors = [.init(key: "startDate", ascending: true)]
        request.fetchLimit = 1
        let results = try await select(request: request)
        return results.first
    }
}
