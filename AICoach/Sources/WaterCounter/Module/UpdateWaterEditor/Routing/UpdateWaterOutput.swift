//  
//  UpdateWaterOutput.swift
//  
//
//  Created by Denis Khlopin on 09.04.2024.
//
import AppStudioUI

public typealias UpdateWaterOutputBlock = ViewOutput<UpdateWaterOutput>

public enum UpdateWaterOutput {
    case updated(Double)
}
