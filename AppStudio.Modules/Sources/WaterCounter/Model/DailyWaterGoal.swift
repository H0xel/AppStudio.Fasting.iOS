//
//  File.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import Foundation

public struct DailyWaterGoal {
    public let id: String
    public var quantity: Double
    public let date: Date

    public init(id: String? = nil, quantity: Double, date: Date) {
        self.id = id ?? UUID().uuidString
        self.quantity = quantity
        self.date = date.startOfTheDay
    }    
}

extension DailyWaterGoal {
    static var `default`: DailyWaterGoal {
        .init(quantity: 2500, date: .now)
    }
}
