//  
//  CustomKeyboardOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//
import AppStudioUI

typealias CustomKeyboardOutputBlock = ViewOutput<CustomKeyboardOutput>

struct CustomKeyboardResult {
    let displayText: String
    let value: Double
    let serving: MealServing
}

enum CustomKeyboardDirection {
    case up
    case down
}

enum CustomKeyboardOutput {
    case valueChanged(CustomKeyboardResult)
    case add(CustomKeyboardResult)
    case dismissed(CustomKeyboardResult)
    case direction(CustomKeyboardDirection)
}
