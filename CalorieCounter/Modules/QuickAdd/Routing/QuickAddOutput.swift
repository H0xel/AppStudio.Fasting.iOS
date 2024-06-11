//  
//  QuickAddOutput.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//
import AppStudioUI

typealias QuickAddOutputBlock = ViewOutput<QuickAddOutput>

enum QuickAddOutput {
    case created(Meal)
    case updated(Meal)
    case logType(logType: LogType)
    case close
}
