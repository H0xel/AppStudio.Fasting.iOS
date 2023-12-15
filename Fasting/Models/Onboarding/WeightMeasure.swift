//
//  WeightMeasure.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

struct WeightMeasure: Codable {
    let value: CGFloat
    let units: WeightUnit

    var valueWithUnits: String {
        "\(Int(value)) \(units.title)"
    }
}
