//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation

public struct DrinkingWater {
    public let id: String
    public let date: Date
    public var quantity: Double

    public init(id: String? = nil, date: Date, quantity: Double) {
        self.id = id ?? UUID().uuidString
        self.date = date
        self.quantity = quantity
    }
}
