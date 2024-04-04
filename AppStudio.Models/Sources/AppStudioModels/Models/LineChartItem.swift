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
    public let dashed: Bool

    public init(title: String,
                lineWidth: CGFloat,
                lineColor: Color,
                values: [LineChartValue],
                dashed: Bool = false) {
        self.title = title
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.values = values
        self.dashed = dashed
    }
}

public struct LineChartValue: Identifiable, Equatable {
    public let id = UUID()
    public let value: Double
    public let label: Date

    public init(value: Double, label: Date) {
        self.value = value
        self.label = label
    }
}

public extension LineChartItem {

    static func trueWeight(values: [LineChartValue], color: Color) -> LineChartItem {
        .init(title: "LineChartItem.trueWeight".localized(bundle: .module),
              lineWidth: 4,
              lineColor: color,
              values: values)
    }

    static func scaleWeight(values: [LineChartValue], color: Color) -> LineChartItem {
        .init(title: "LineChartItem.scaleWeight".localized(bundle: .module),
              lineWidth: 2,
              lineColor: color,
              values: values)
    }

    static func weightGoal(values: [LineChartValue], color: Color) -> LineChartItem {
        .init(title: "LineChartItem.goalWeight".localized(bundle: .module),
              lineWidth: 1,
              lineColor: color,
              values: values,
              dashed: true)
    }

    var empty: LineChartItem {
        .init(title: title,
              lineWidth: 0,
              lineColor: lineColor,
              values: values)
    }

    static func hidden(values: [LineChartValue]) -> LineChartItem {
        .init(title: "",
              lineWidth: 0,
              lineColor: .clear,
              values: values)
    }

    static var scaleWeightMock: LineChartItem {
        .init(
            title: "Scale weight",
            lineWidth: 4,
            lineColor: .blue,
            values: [
                .init(value: 55, label: Date().add(days: -6)),
                .init(value: 56, label: Date().add(days: -5)),
                .init(value: 54, label: Date().add(days: -4)),
                .init(value: 53, label: Date().add(days: -3)),
                .init(value: 57, label: Date().add(days: -2)),
                .init(value: 55, label: Date().add(days: -1)),
                .init(value: 60, label: Date())
            ]
        )
    }

    static var trueWeightMock: LineChartItem {
        .init(
            title: "True weight",
            lineWidth: 2,
            lineColor: .green,
            values: [
                .init(value: 58, label: Date().add(days: -6)),
                .init(value: 54, label: Date().add(days: -5)),
                .init(value: 55, label: Date().add(days: -4)),
                .init(value: 54, label: Date().add(days: -3)),
                .init(value: 53, label: Date().add(days: -2)),
                .init(value: 56, label: Date().add(days: -1)),
                .init(value: 58, label: Date())
            ]
        )
    }

    static var trueWeightMockLong: LineChartItem {
        .init(
            title: "True weight",
            lineWidth: 2,
            lineColor: .green,
            values: (0...360).map {
                .init(
                    value: Double(Int.random(in: 60 ... 100)),
                    label: Date().add(days: -$0)
                )
            }
        )
    }

    static var scaleWeightMockLong: LineChartItem {
        .init(
            title: "Scale weight",
            lineWidth: 4,
            lineColor: .blue,
            values: (0...360).map {
                .init(
                    value: Double(Int.random(in: 60 ... 100)),
                    label: Date().add(days: -$0)
                )
            }
        )
    }
}

