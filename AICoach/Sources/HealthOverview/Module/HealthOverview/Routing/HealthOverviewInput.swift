//  
//  HealthOverviewInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Foundation
import Combine
import AppStudioUI
import FastingWidget
import AppStudioModels

public struct HealthOverviewInput {
    
    let fastingWidget: FastingWidget
    let weightUnits: WeightUnit

    public init(fastingWidget: FastingWidget, weightUnits: WeightUnit) {
        self.fastingWidget = fastingWidget
        self.weightUnits = weightUnits
    }
}
