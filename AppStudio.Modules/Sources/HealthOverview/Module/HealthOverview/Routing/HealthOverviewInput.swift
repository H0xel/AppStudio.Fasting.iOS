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
    let monetizationIsAvailable: AnyPublisher<Bool, Never>

    public init(fastingWidget: FastingWidget, weightUnits: WeightUnit, monetizationIsAvailable: AnyPublisher<Bool, Never>) {
        self.fastingWidget = fastingWidget
        self.weightUnits = weightUnits
        self.monetizationIsAvailable = monetizationIsAvailable
    }
}
