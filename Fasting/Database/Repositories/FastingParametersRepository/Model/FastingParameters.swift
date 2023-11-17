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

    init(id: String,
         start: Date,
         plan: FastingPlan,
         currentDate: Date? = nil,
         creationDate: Date) {
        self.id = id
        self.start = start.withoutSeconds
        self.plan = plan
        self.currentDate = currentDate?.withoutSeconds
        self.creationDate = creationDate
    }
}
