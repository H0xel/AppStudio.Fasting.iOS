//  
//  UpdateWeightInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation
import AppStudioModels

public struct UpdateWeightInput {

    let date: Date
    let units: WeightUnit

    public init(date: Date, units: WeightUnit) {
        self.date = date
        self.units = units
    }
}
