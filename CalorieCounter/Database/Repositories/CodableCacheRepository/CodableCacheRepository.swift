//
//  CodableCacheRepository.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 19.01.2024.
//

import MunicornCoreData
import Dependencies
import Foundation

protocol CodableCacheRepository {
    func set(key: String, value: String, for type: CodableCacheType) async throws -> CodableCache
    func value(key: String, of type: CodableCacheType, cacheInterval: TimeInterval?) async throws -> String?
    func clearAll(of type: CodableCacheType) async throws
    func clear(key: String, of type: CodableCacheType) async throws
}
