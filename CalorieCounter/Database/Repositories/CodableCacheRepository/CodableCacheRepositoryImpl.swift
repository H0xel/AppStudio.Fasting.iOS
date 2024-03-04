//
//  CodableCacheRepositoryImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.01.2024.
//

import MunicornCoreData
import Dependencies
import CoreData

class CodableCacheRepositoryImpl: CoreDataBaseRepository<CodableCache> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension CodableCacheRepositoryImpl: CodableCacheRepository {
    private func predicate(forKey key: String, andType type: CodableCacheType) -> NSPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate.init(format: "key == %@", key),
            NSPredicate.init(format: "type == \(type.rawValue)")
        ])
    }

    func set(key: String, value: String, for type: CodableCacheType) async throws -> CodableCache {
        let request = CodableCache.request()
        request.predicate = predicate(forKey: key, andType: type)
        let existedObject = try await select(request: request).first

        return try await save(
            CodableCache(id: existedObject?.id, key: key, type: type, date: .now, value: value)
        )
    }

    func value(key: String, of type: CodableCacheType, cacheInterval: TimeInterval?) async throws -> String? {
        let request = CodableCache.request()
        var predicates: [NSPredicate] = [predicate(forKey: key, andType: type)]

        if let cacheInterval {
            let startDate = Date.now.addingTimeInterval(-1 * cacheInterval)
            predicates.append(NSPredicate(format: "date >= %@", startDate as NSDate))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return try await select(request: request).first?.value
    }

    func clearAll(of type: CodableCacheType) async throws {
        let request = CodableCache.request()
        request.predicate = NSPredicate(format: "type == \(type.rawValue)")
        let deleteRequest = CodableCache.batchDeleteRequest(fetchRequest: request)

        try await delete(batchDeleteRequest: deleteRequest)
    }

    func clear(key: String, of type: CodableCacheType) async throws {
        let request = CodableCache.request()
        request.predicate = predicate(forKey: key, andType: type)
        let deleteRequest = CodableCache.batchDeleteRequest(fetchRequest: request)

        try await delete(batchDeleteRequest: deleteRequest)
    }
}
