//
//  DateChartScaleModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import Charts
import AppStudioModels

public struct DateChartScaleModifier: ViewModifier {

    private let chartScale: DateChartScale

    public init(chartScale: DateChartScale) {
        self.chartScale = chartScale
    }

    public func body(content: Content) -> some View {
        content
            .chartXAxis {
                AxisMarks(preset: .inset, position: .bottom, values: values) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(
                            date.currentLocaleFormatted(with: chartScale.dateFormat),
                            collisionResolution: .greedy
                        )
                        .foregroundStyle(Color.studioBlackLight)
                        AxisGridLine(
                            stroke: .init(lineWidth: .lineWidth,
                                          lineCap: .square,
                                          dash: [4, 4])
                        )
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    }
                }
            }
    }

    private var values: AxisMarkValues {
        switch chartScale {
        case .week: .automatic(desiredCount: 7)
        case .month: .automatic(desiredCount: 10)
        case .threeMonth: .stride(by: .weekOfYear)
        }
    }
}

private extension CGFloat {
    static let lineWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(DateChartScaleModifier(chartScale: .month))
}
