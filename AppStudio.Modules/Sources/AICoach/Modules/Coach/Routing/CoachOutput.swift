//  
//  CoachOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//
import AppStudioUI

public typealias CoachOutputBlock = ViewOutput<CoachOutput>

public enum CoachOutput {
    case focusChanged(Bool)
    case presentMultiplePaywall
}
