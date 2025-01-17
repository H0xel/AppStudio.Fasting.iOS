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

    var timeFasted: Double {
        let diffrence = finishedDate.timeIntervalSince1970 - startedDate.timeIntervalSince1970
        let hours = diffrence.toHour
        let minutes = diffrence.toMinutesInt
        return Double(hours) + Double(minutes) / 60.0
    }

    var stage: FastingStage {
        let diffrence = finishedDate.timeIntervalSince1970 - startedDate.timeIntervalSince1970
        return diffrence.fastingStage
    }
}

extension FastingIntervalHistory {
    static func empty(statedDate: Date, plan: FastingPlan) -> FastingIntervalHistory {
        .init(currentDate: statedDate,
              startedDate: statedDate,
              finishedDate: statedDate,
              plan: plan)
    }
}
