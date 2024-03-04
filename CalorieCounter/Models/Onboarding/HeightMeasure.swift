//
//  HeightMeasure.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

struct FeetMeasure {
    let feets: Int
    let inches: Int
}

struct HeightMeasure: Codable {

    let units: HeightUnit
    private let cmValue: CGFloat

    init(centimeters: CGFloat) {
        cmValue = centimeters
        self.units = .cm
    }

    init(feet: CGFloat, inches: CGFloat) {
        let centimetersPerFoot = 30.48
        let centimetersPerInch = 2.54
        cmValue = feet * centimetersPerFoot + inches * centimetersPerInch
        units = .ft
    }

    var valueWithUnits: String {
        switch units {
        case .ft:
            feetValueWithUnits
        case .cm:
            cmValueWithUnits
        }
    }

    var normalizeValue: CGFloat {
        cmValue
    }

    var feets: FeetMeasure {
        let centimetersPerInch = 2.54

        let totalInches = cmValue / centimetersPerInch
        let feet = totalInches / 12.0
        let remainingInches = totalInches.truncatingRemainder(dividingBy: 12.0)
        return .init(feets: Int(feet), inches: Int(remainingInches))
    }

    private var cmValueWithUnits: String {
        let value = String(Int(cmValue))
        return "\(value) \(units.title)"
    }

    private var feetValueWithUnits: String {
        let feets = feets
        let feetTitle = NSLocalizedString("HeightUnit.ft", comment: "ft")
        let inchTitle = NSLocalizedString("HeightUnit.in", comment: "in")
        return "\(Int(feets.feets)) \(feetTitle) \(Int(feets.inches)) \(inchTitle)"
    }
}
