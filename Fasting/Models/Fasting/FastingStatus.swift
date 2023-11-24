//
//  FastingStatus.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

enum FastingStatus: Hashable {
    case unknown
    case active(FastingActiveState)
    case inActive(InActiveFastingStage)
}

extension FastingStatus {
    var isFinished: Bool {
        switch self {
        case .active(let fastingActiveState):
            return fastingActiveState.isFinished
        case .inActive:
            return false
        case .unknown:
            return false
        }
    }
}
