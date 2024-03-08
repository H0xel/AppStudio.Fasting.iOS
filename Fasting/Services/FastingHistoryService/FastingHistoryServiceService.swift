//  
//  FastingHistoryServiceService.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation

protocol FastingHistoryService {
    func saveHistory(interval: FastingInterval,
                     startedAt startedDate: Date,
                     finishedAt finishedDate: Date) async throws
    func selectLast(count: Int) async throws -> [FastingIntervalHistory]
    func history(for date: Date) async throws -> [FastingIntervalHistory]
    func history(for dates: [Date]) async throws -> [Date: FastingIntervalHistory]
}
