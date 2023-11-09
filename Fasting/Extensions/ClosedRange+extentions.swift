//
//  ClosedRange+Extentions.swift
//  Fasting
//
//  Created by Denis Khlopin on 08.11.2023.
//

import Foundation

extension ClosedRange<Date> {
    static func threeDaysUntilNow(allowFuture: Bool) -> ClosedRange<Date> {
        let min = Date().addingTimeInterval(.day * -3)
        let max = Date().addingTimeInterval(allowFuture ? .day : 0)
        return min...max
    }
}
