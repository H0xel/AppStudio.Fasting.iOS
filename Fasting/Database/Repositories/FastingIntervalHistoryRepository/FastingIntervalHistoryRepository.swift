//
//  FastingIntervalHistoryRepository.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import MunicornCoreData
import Foundation

protocol FastingIntervalHistoryRepository {
    @discardableResult
    func save(history: FastingIntervalHistory) async throws -> FastingIntervalHistory
    func selectLast(count: Int) async throws -> [FastingIntervalHistory]
}
