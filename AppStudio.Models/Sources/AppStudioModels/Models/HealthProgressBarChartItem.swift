//
//  HealthProgressBarChartItem.swift
//  
//
//  Created by Руслан Сафаргалеев on 25.03.2024.
//

import SwiftUI

public struct HealthProgressBarChartItem: Identifiable, Equatable {
    public let id = UUID()
    public let value: Double
    public let lineValue: Double
    public let color: Color
    public let label: String

    public init(value: Double, lineValue: Double, color: Color, label: String) {
        self.value = value
        self.color = color
        self.label = label
        self.lineValue = lineValue
    }
}

public extension HealthProgressBarChartItem {
    static var mock: [HealthProgressBarChartItem] {
        [
            .init(value: 7.5, lineValue: 16, color: .red, label: "Fri"),
            .init(value: 9, lineValue: 16, color: .blue, label: "Sat"),
            .init(value: 6.8, lineValue: 16, color: .purple, label: "Sun"),
            .init(value: 18.2, lineValue: 12, color: .secondary, label: "Mon"),
            .init(value: 15.6, lineValue: 12, color: .green, label: "Tue"),
            .init(value: 2, lineValue: 16, color: .blue, label: "Wed"),
            .init(value: 0, lineValue: 16, color: .blue, label: "Thu")
        ]
    }
}
