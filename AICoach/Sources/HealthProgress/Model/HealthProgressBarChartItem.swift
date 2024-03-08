//
//  HealthProgressBarChartItem.swift
//
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
//

import SwiftUI

public struct HealthProgressBarChartItem: Identifiable, Equatable {
    public let id = UUID()
    let value: Double
    let lineValue: Double
    let color: Color
    let label: String

    public init(value: Double, lineValue: Double, color: Color, label: String) {
        self.value = value
        self.color = color
        self.label = label
        self.lineValue = lineValue
    }
}

extension HealthProgressBarChartItem {
    static var mock: [HealthProgressBarChartItem] {
        [
            .init(value: 7.5, lineValue: 16, color: .studioPurple, label: "Fri"),
            .init(value: 9, lineValue: 16, color: .studioRed, label: "Sat"),
            .init(value: 6.8, lineValue: 16, color: .studioPurple, label: "Sun"),
            .init(value: 18.2, lineValue: 12, color: .studioSky, label: "Mon"),
            .init(value: 15.6, lineValue: 12, color: .studioGreen, label: "Tue"),
            .init(value: 2, lineValue: 16, color: .studioBlue, label: "Wed"),
            .init(value: 0, lineValue: 16, color: .studioBlue, label: "Thu")
        ]
    }
}
