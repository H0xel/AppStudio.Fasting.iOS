//
//  AvailableIntervalsForNotifications.swift
//  Fasting
//
//  Created by Amakhin Ivan on 20.06.2024.
//

import Foundation

enum AvailableIntervalsForNotifications {
    case one(ClosedRange<Double>)
    case two(ClosedRange<Double>, ClosedRange<Double>)
}
