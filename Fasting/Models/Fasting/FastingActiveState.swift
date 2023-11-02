//
//  FastingActiveState.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

struct FastingActiveState: Hashable {
    let interval: TimeInterval
    let stage: FastingStage
    let isFinished: Bool
}
