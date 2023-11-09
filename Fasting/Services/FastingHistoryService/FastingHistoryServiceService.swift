//  
//  FastingHistoryServiceService.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//
import Foundation

protocol FastingHistoryServiceService {
    func saveHistory(interval: FastingInterval, finishedAt finishedDate: Date) async throws
}
