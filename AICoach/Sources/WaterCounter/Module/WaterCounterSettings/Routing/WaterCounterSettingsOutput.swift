//  
//  WaterCounterSettingsOutput.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//
import AppStudioUI

public typealias WaterCounterSettingsOutputBlock = ViewOutput<WaterCounterSettingsOutput>

public enum WaterCounterSettingsOutput {
    case close
    case updateSettings
}
