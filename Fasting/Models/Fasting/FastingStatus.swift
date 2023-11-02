//
//  FastingStatus.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

enum FastingStatus: Hashable {
    case active(FastingActiveState)
    case inActive(InActiveFastingStage)
}
