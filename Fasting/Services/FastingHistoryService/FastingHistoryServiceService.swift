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
}
