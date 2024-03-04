//
//  Numeric+Extensions.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.01.2024.
//

import AppStudioFoundation
import Foundation

public extension Numeric {
    var formattedCaloriesString: String {
        var intValue = 0
        switch self {
        case let value as Int:
            intValue = value
        case let value as Double:
            intValue = Int(value)
        case let value as CGFloat:
            intValue = Int(value)
        default:
            break
        }
        let string = Double(intValue).decimalFormat() ?? ""
        let components = string.components(separatedBy: .whitespaces)
        return components.joined(separator: ",")
    }
}
