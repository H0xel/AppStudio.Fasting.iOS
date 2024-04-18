//  
//  RateAppOutput.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//
import AppStudioUI

public typealias RateAppOutputBlock = ViewOutput<RateAppOutput>

public enum RateAppOutput {
    case close
    case rate(stars: Int, comment: String)
}
