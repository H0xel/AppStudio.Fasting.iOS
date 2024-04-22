//  
//  HealthOverviewOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//
import AppStudioUI
import Foundation

public typealias HealthOverviewOutputBlock = ViewOutput<HealthOverviewOutput>

public enum HealthOverviewOutput {
    case profileTapped
    case showPaywall
    case showPopUpPaywall
}
