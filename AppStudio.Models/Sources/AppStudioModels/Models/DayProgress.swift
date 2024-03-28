//
//  DayProgress.swift
//  
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import Foundation

public struct DayProgress: Hashable {
    public let goal: CGFloat
    public let result: CGFloat

    public init(goal: CGFloat, result: CGFloat) {
        self.goal = goal
        self.result = result
    }
}
