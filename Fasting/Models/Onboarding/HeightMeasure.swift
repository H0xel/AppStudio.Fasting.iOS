//
//  HeightMeasure.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

struct HeightMeasure: Codable {
    let value: CGFloat
    let units: HeightUnit

    var valueWithUnits: String {
        "\(Int(value)) \(units.title)"
    }

    var centimeters: Double {
        switch units {
        case .ft:
            let centimetersPerFoot = 30.48
            let centimetersPerInch = 2.54
            return value * centimetersPerFoot
        case .cm:
            return value
        }
    }
}
