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

    var withOneFractionIfNeeded: String {
        decimalFormatterWithOneFraction.string(from: NSNumber(value: self)) ?? .init(format: "%.0f", "\(self)")
    }

    func isOutOfRange() -> Bool {
        if self < Double(Int.min) || self > Double(Int.max){
            return true
        }

        return false
    }

    func getIntegerAndFractionalPartsAsInt(fractionalMultiplier: Double) -> (integerPart: Int, fractionalPart: Int) {
        let integerPart = Int(self)

        let fractionalPart = self - Double(integerPart)

        let fractionalPartAsInt = Int(fractionalPart * fractionalMultiplier)

        return (integerPart, fractionalPartAsInt)
    }
}
