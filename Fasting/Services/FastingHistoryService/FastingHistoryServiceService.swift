//  
//  FastingHistoryServiceService.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation
import Combine

protocol FastingHistoryService {
    var historyObserver: FastingIntervalHistoryObserver { get }
    func save(history: FastingIntervalHistory) async throws
    func saveHistory(interval: FastingInterval,
                     startedAt startedDate: Date,
                     finishedAt finishedDate: Date) async throws
    func selectLast(count: Int) async throws -> [FastingIntervalHistory]
    func history(for date: Date) async throws -> [FastingIntervalHistory]
    func history(for dates: [Date]) async throws -> [Date: FastingIntervalHistory]
    func history(byId id: String) async throws -> FastingIntervalHistory?
    func deleteAll() async throws
    func delete(byId: String) async throws
    func history() async throws -> [FastingIntervalHistory]
}
