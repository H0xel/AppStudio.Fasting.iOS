//  
//  CustomKeyboardOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//
import AppStudioUI

typealias CustomKeyboardOutputBlock = ViewOutput<ContainerKeyboardOutput>

struct CustomKeyboardResult {
    let displayText: String
    let value: Double
    let serving: MealServing

    var servingMultiplier: Double {
        serving.multiplier(for: value)
    }
}

enum CustomKeyboardDirection {
    case up
    case down
}

enum ContainerKeyboardOutput {
    case valueChanged(CustomKeyboardResult)
    case add(CustomKeyboardResult)
    case dismissed(CustomKeyboardResult)
    case direction(CustomKeyboardDirection)
    case servingChanged(CustomKeyboardResult)
}
