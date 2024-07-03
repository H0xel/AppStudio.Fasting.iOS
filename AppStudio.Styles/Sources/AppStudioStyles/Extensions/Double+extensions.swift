//
//  Double+extensions.swift
//
//
//  Created by Руслан Сафаргалеев on 21.06.2024.
//

import Foundation

public extension Double {
    var withoutDecimalsIfNeeded: String {
        decimalFormatter.string(from: NSNumber(value: self)) ?? .init(format: "%.0f", "\(self)")
    }
}
