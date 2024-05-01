//
//  WeightMeasure.swift
//  
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation

public struct WeightMeasure: Codable, Equatable {
    public let value: CGFloat
    public let units: WeightUnit

    private let kgValue: CGFloat

    public init(value: CGFloat, units: WeightUnit = .kg) {
        self.value = value
        self.units = units
        if units == .kg {
            self.kgValue = value
        } else {
            self.kgValue = WeightUnit.convertToKg(lbsValue: value)
        }
    }

    public var wholeValueWithUnits: String {
        let value = String(format: "%.0f", value)
        return "\(value) \(units.title)"
    }

    public var valueWithUnits: String {
        let value = String(format: "%.2f", value)
        return "\(value) \(units.title)"
    }

    public var valueWithSingleDecimalInNeeded: String {
        var value = String(format: "%.1f", value)
        if value.hasSuffix(".0") {
            value.removeLast(2)
        }
        return "\(value) \(units.title)"
    }

    public var normalizeValue: CGFloat {
        kgValue
    }
}
