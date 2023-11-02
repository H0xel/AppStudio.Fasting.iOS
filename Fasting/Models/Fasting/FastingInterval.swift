//
//  FastingInterval.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

struct FastingInterval {
    let start: Date
    let plan: FastingPlan
    var currentDate: Date?

    var startDate: Date {
        currentDate ?? start
    }

    var endDate: Date {
        startDate.addingTimeInterval(plan.duration)
    }
}

extension FastingInterval {
    static var empty: FastingInterval {
        .init(start: .now, plan: .beginner)
    }
}
