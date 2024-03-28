//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation

struct DrinkingWater {
    let id: String
    let date: Date
    var quantity: Double

    init(id: String? = nil, date: Date, quantity: Double) {
        self.id = id ?? UUID().uuidString
        self.date = date
        self.quantity = quantity
    }
}
