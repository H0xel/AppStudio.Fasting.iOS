//  
//  UpdateWeightOutput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//
import AppStudioUI

public typealias UpdateWeightOutputBlock = ViewOutput<UpdateWeightOutput>

public enum UpdateWeightOutput {
    case weightUpdated(WeightHistory)
}
