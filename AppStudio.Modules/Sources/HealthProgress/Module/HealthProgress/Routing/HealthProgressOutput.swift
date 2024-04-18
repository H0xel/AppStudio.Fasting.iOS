//  
//  HealthProgressOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//
import AppStudioUI

public typealias HealthProgressOutputBlock = ViewOutput<HealthProgressOutput>

public enum HealthProgressOutput {
    // add Output parameters here
    case novaQuestion(String)
    case delete(historyId: String)
    case edit(historyId: String)
    case addHistory
    case updateInput
    case presentMultipleProductPaywall
}
