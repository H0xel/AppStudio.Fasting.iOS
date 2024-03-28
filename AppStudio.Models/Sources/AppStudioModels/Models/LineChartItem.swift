//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 25.03.2024.
//

import SwiftUI

public struct LineChartItem: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let lineColor: Color
    public let lineWidth: CGFloat
    public let values: [LineChartValue]

    public init(title: String, lineWidth: CGFloat, lineColor: Color, values: [LineChartValue]) {
        self.title = title
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.values = values
    }
}

public struct LineChartValue: Identifiable, Equatable {
    public let id = UUID()
    public let value: Double
    public let label: String

    public init(value: Double, label: String) {
        self.value = value
        self.label = label
    }
}

public extension LineChartItem {

    var empty: LineChartItem {
        .init(title: title,
              lineWidth: 0,
              lineColor: lineColor,
              values: values)
    }

    static var scaleWeightMock: LineChartItem {
        .init(
            title: "Scale weight",
            lineWidth: 4,
            lineColor: .blue,
            values: [
                .init(value: 55, label: "Fri"),
                .init(value: 56, label: "Sat"),
                .init(value: 54, label: "Sun"),
                .init(value: 53, label: "Mon"),
                .init(value: 57, label: "Tue"),
                .init(value: 55, label: "Wed"),
                .init(value: 60, label: "Thu")
            ]
        )
    }

    static var trueWeightMock: LineChartItem {
        .init(
            title: "True weight",
            lineWidth: 2,
            lineColor: .green,
            values: [
                .init(value: 58, label: "Fri"),
                .init(value: 54, label: "Sat"),
                .init(value: 55, label: "Sun"),
                .init(value: 54, label: "Mon"),
                .init(value: 53, label: "Tue"),
                .init(value: 56, label: "Wed"),
                .init(value: 58, label: "Thu")
            ]
        )
    }
}

