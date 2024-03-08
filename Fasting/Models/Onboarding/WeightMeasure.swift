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

    private let kgValue: CGFloat

    init(value: CGFloat, units: WeightUnit = .kg) {
        self.value = value
        self.units = units
        if units == .kg {
            self.kgValue = value
        } else {
            self.kgValue = WeightUnit.convertToKg(lbsValue: value)
        }
    }

    var valueWithUnits: String {
        let value = String(format: "%.2f", value)
        return "\(value) \(units.title)"
    }

    var normalizeValue: CGFloat {
        kgValue
    }
}
