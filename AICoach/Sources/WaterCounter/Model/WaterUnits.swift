//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation

public enum WaterUnits: String {
    case liters
    case ounces

    static let allUnits: [WaterUnits] = [.liters, .ounces]

    public func formatGlobal(value: Double) -> String {
        switch self {
        case .liters:
            valueToGlobal(value: value).formatRounded(to: 2).cutTrailingZeros()
        case .ounces:
            valueToGlobal(value: value).formatRounded(to: 0)
        }
    }

    public func format(value: Double) -> String {
        switch self {
        case .liters:
            valueToLocal(value: value).formatRounded(to: 0)
        case .ounces:
            valueToLocal(value: value).formatRounded(to: 1).cutTrailingZeros()
        }
    }

    func valueToLocal(value: Double) -> Double {
        switch self {
        case .liters:
            value
        case .ounces:
            ((value * 33.814) / 1000).round1()
        }
    }

    func valueToGlobal(value: Double) -> Double {
        switch self {
        case .liters:
            (value / 1000).round2()
        case .ounces:
            ((value * 33.814) / 1000).round2()
        }
    }

    func globalToValue(value: Double) -> Double {
        switch self {
        case .liters:
            (value * 1000).round2()
        case .ounces:
            (value * 1000 / 33.814).round2()
        }
    }

    func localToValue(value: Double) -> Double {
        switch self {
        case .liters:
            value
        case .ounces:
            ((value / 33.814) * 1000).round1()
        }
    }

    public var unitsGlobalFullTitle: String {
        "WaterUnits.unitsGlobalFullTitle.\(rawValue)".localized(bundle: .module)
    }

    public var unitsGlobalTitle: String {
        "WaterUnits.unitsGlobalTitle.\(rawValue)".localized(bundle: .module)
    }

    var unitsTitle: String {
        "WaterUnits.unitsTitle.\(rawValue)".localized(bundle: .module)
    }

    var predefinedValues: [DoubleValuePredefinedValue] {
        switch self {
        case .liters:
            [.init(value: 250), .init(value: 500), .init(value: 1000)]
        case .ounces:
            [.init(value: 8), .init(value: 12), .init(value: 16)]
        }
    }

}

private extension Double {
    func formatRounded(to: Int) -> String {
        if to == 0 {
            return "\(Int(self))"
        }
        let delimeter: Double = (0..<to).reduce(into: 1.0) { res, _ in res *= 10 }
        return String(format: "%.\(to)f", (self * delimeter).rounded() / delimeter)
    }

    func round2() -> Double {
        (self * 100.0).rounded() / 100.0
    }

    func round1() -> Double {
        (self * 100.0).rounded() / 100.0
    }
}

private extension String {
    func cutTrailingZeros() -> String {
        var result = self
        if !result.contains(".") && !result.contains(".") {
            return result
        }
        while !result.isEmpty {
            if result.last == "." || result.last == "," {
                result.removeLast()
                return result
            }
            if result.last == "0" {
                result.removeLast()
                continue
            }
            return result
        }
        return result
    }
}
