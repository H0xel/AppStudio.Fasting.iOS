//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import AppStudioFoundation

public struct WaterSettings {
    public let id: String
    public let date: Date
    public var prefferedValue: Double
    public var units: WaterUnits

    public init(id: String? = nil, date: Date, prefferedValue: Double, units: WaterUnits) {
        self.id = id ?? UUID().uuidString
        self.date = date.startOfTheDay
        self.prefferedValue = prefferedValue
        self.units = units
    }
}

extension WaterSettings {
    static var `default`: WaterSettings {
        .init(date: .now, prefferedValue: WaterUnits.ounces.localToValue(value: 8), units: .ounces)
    }
}
