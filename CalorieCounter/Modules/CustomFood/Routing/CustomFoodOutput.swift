//  
//  CustomFoodOutput.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//
import AppStudioUI

typealias CustomFoodOutputBlock = ViewOutput<CustomFoodOutput>

enum CustomFoodOutput {
    case save(MealItem)
    case edit(MealItem)
}
