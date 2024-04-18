//  
//  FastingHistoryOutput.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//
import AppStudioUI

typealias FastingHistoryOutputBlock = ViewOutput<FastingHistoryOutput>

enum FastingHistoryOutput {
    case close
    case delete(historyId: String)
    case edit(historyId: String)
    case addHistory
    case updateWater
}
