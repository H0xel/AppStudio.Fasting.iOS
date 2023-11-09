//
//  FastingIntervalHistory.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Foundation

struct FastingIntervalHistory {
    let id: String
    let currentDate: Date
    let startedDate: Date
    let finishedDate: Date
    let plan: FastingPlan

    init(
        id: String = UUID().uuidString,
        currentDate: Date,
        startedDate: Date,
        finishedDate: Date,
        plan: FastingPlan
    ) {
        self.id = id
        self.currentDate = currentDate
        self.startedDate = startedDate
        self.finishedDate = finishedDate
        self.plan = plan
    }
}
