//
//  Double+Extensions.swift
//  Fasting
//
//  Created by Denis Khlopin on 28.11.2023.
//

import Foundation

extension Double {
    func scale(from fromRange: ClosedRange<Double>, to toRange: ClosedRange<CGFloat>) -> CGFloat {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func scale(from fromRange: ClosedRange<Double>, to toRange: ClosedRange<Double>) -> Double {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }
}
