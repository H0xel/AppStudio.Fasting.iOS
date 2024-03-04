//  
//  FoodOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//
import AppStudioUI

typealias FoodOutputBlock = ViewOutput<FoodOutput>

enum FoodOutput {
    case switchTabBar(isHidden: Bool)
}
