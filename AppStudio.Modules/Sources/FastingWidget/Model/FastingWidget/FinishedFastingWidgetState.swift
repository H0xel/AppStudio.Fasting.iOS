//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import Foundation

public struct FinishedFastingWidgetState {
    let fastingId: String?
    let startDate: Date
    let finishedDate: Date
    let finishPhase: FastingWidgetPhase?

    public init(fastingId: String?,
                startDate: Date,
                finishedDate: Date,
                finishPhase: FastingWidgetPhase?) {
        self.startDate = startDate
        self.finishedDate = finishedDate
        self.finishPhase = finishPhase
        self.fastingId = fastingId
    }
}
