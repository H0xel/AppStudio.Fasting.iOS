//
//  OnboardingCalculatedData.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
import AppStudioModels

struct OnboardingCalculatedData: Codable {
    let specialEventWeight: WeightMeasure?
    let desiredWeightDate: Date

    let paywallTitle: String
    let paywallBullets: [String]
    let fromAgesTitle: String
}
