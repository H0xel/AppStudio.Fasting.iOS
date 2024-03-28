//
//  HealthOveviewInitializer.swift
//
//
//  Created by Руслан Сафаргалеев on 08.03.2024.
//

import Foundation
import FastingWidget
import WeightWidget

public class HealthOveviewInitializer {

    public init() {}

    public func initialize(calendarProgressService: CalendarProgressService) {
        CalendarProgressServiceKey.liveValue = calendarProgressService
    }
}
