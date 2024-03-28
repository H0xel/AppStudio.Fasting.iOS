//
//  File.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//

import Foundation

struct DailyWaterGoal {
    let id: String
    var quantity: Double
    let date: Date

    init(id: String? = nil, quantity: Double, date: Date) {
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
