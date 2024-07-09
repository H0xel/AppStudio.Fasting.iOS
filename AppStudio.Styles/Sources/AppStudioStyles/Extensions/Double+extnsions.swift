//
//  Double+extnsions.swift
//
//
//  Created by Amakhin Ivan on 20.06.2024.
//

import Foundation

public extension Double {
    func getIntegerAndFractionalPartsAsInt(fractionalMultiplier: Double) -> (integerPart: Int, fractionalPart: Int) {
        let integerPart = Int(self)

        let fractionalPart = self - Double(integerPart)

        let fractionalPartAsInt = Int(fractionalPart * fractionalMultiplier)

        return (integerPart, fractionalPartAsInt)
    }
}
