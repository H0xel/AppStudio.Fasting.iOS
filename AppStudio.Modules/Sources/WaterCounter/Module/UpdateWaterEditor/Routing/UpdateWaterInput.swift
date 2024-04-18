//  
//  UpdateWaterInput.swift
//  
//
//  Created by Denis Khlopin on 09.04.2024.
//
import Foundation

public struct UpdateWaterInput {
    // add Input parameters here
    public let units: WaterUnits
    public let date: Date
    public let allWater: [Date: DrinkingWater]

    public init(units: WaterUnits, date: Date, allWater: [Date : DrinkingWater] = [:]) {
        self.units = units
        self.date = date
        self.allWater = allWater
    }
}
