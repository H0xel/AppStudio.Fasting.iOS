//  
//  WeightGoalUpdateOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//
import AppStudioUI
import AppStudioModels

typealias WeightGoalUpdateOutputBlock = ViewOutput<WeightGoalUpdateOutput>

enum WeightGoalUpdateOutput {
    case save(WeightMeasure)
}
