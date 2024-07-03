//
//  String+extensions.swift
//
//
//  Created by Руслан Сафаргалеев on 21.06.2024.
//

import Foundation

var decimalFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    formatter.alwaysShowsDecimalSeparator = false
    formatter.usesGroupingSeparator = false
    formatter.decimalSeparator = "."
    return formatter
}

public extension String {
    var withoutDecimalsIfNeeded: String {
        decimalFormatter.string(from: NSNumber(value: Double(self) ?? 0)) ?? self
    }
}
