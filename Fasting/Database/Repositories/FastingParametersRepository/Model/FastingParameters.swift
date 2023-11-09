//
//  FastingParameters.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import Foundation

struct FastingParameters {
    let id: String
    let start: Date
    let plan: FastingPlan
    var currentDate: Date?
    let creationDate: Date

    var asInterval: FastingInterval {
        FastingInterval(start: start,
                        plan: plan,
                        currentDate: currentDate)
    }
}
