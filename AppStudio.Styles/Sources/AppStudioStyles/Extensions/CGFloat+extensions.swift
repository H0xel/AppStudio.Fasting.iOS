//
//  CGFloat+extensions.swift
//
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import Foundation

extension CGFloat {
    func scale(from fromRange: ClosedRange<CGFloat>, to toRange: ClosedRange<CGFloat>) -> CGFloat {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func scale(from fromRange: ClosedRange<CGFloat>, to toRange: ClosedRange<Double>) -> Double {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func scale(from fromRange: ClosedRange<Double>, to toRange: ClosedRange<CGFloat>) -> CGFloat {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }
}

extension Double {
    func scale(from fromRange: ClosedRange<Double>, to toRange: ClosedRange<CGFloat>) -> CGFloat {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func scale(from fromRange: ClosedRange<Double>, to toRange: ClosedRange<Double>) -> Double {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func scale(from fromRange: ClosedRange<CGFloat>, to toRange: ClosedRange<Double>) -> CGFloat {
        let positionInRange = (self - fromRange.lowerBound) / (fromRange.upperBound - fromRange.lowerBound)
        return (positionInRange * (toRange.upperBound - toRange.lowerBound)) + toRange.lowerBound
    }

    func roundToNearest(_ roundValue: Double) -> Double {
        let roundedValue = (self / roundValue).rounded(.toNearestOrEven) * roundValue
        return roundedValue
    }
}
