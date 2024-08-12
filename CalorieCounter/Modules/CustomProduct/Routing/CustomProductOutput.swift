//  
//  CustomProductOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//
import AppStudioUI

typealias CustomProductOutputBlock = ViewOutput<CustomProductOutput>

enum CustomProductOutput {
    case add(MealItem)
    case log(MealItem)
}
