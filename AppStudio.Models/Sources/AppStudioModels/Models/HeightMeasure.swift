//
//  HeightMeasure.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import Foundation

public struct FeetMeasure {
    public let feets: Int
    public let inches: Int

    public init(feets: Int, inches: Int) {
        self.feets = feets
        self.inches = inches
    }
}

public struct HeightMeasure: Codable {

    public let units: HeightUnit
    private let cmValue: CGFloat

    public init(value: CGFloat, units: HeightUnit) {
        switch units {
        case .ft:
            self.init(feet: value, inches: 0)
        case .cm:
            self.init(centimeters: value)
        }
    }

    enum CodingKeys: String, CodingKey {
        case units
        case value
        case cmValue
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.units = try container.decode(HeightUnit.self, forKey: .units)
        self.cmValue = try container.decodeIfPresent(CGFloat.self, forKey: .cmValue) ??
        container.decode(CGFloat.self, forKey: .value)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.units, forKey: .units)
        try container.encode(self.cmValue, forKey: .cmValue)
    }

    public init(centimeters: CGFloat) {
        cmValue = centimeters
        self.units = .cm
    }

    public init(feet: CGFloat, inches: CGFloat) {
        let centimetersPerFoot = 30.48
        let centimetersPerInch = 2.54
        cmValue = feet * centimetersPerFoot + inches * centimetersPerInch
        units = .ft
    }

    public var valueWithUnits: String {
        switch units {
        case .ft:
            feetValueWithUnits
        case .cm:
            cmValueWithUnits
        }
    }

    public var normalizeValue: CGFloat {
        cmValue
    }

    public var feets: FeetMeasure {
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
        let feetTitle = "HeightUnit.ft".localized(bundle: .module)
        let inchTitle = "HeightUnit.in".localized(bundle: .module)
        return "\(Int(feets.feets)) \(feetTitle) \(Int(feets.inches)) \(inchTitle)"
    }
}
