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
                AxisMarks(preset: .aligned, values: values) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(date.currentLocaleFormatted(with: chartScale.dateFormat),
                                       collisionResolution: chartScale == .week ? .disabled : .greedy)
                            .foregroundStyle(Color.studioBlackLight)
                        AxisGridLine(stroke: .init(lineWidth: .lineWidth,
                                                   lineCap: .square,
                                                   dash: [4, 4]))
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    }
                }
            }
    }

    private var values: AxisMarkValues {
        switch chartScale {
        case .week: return .stride(by: .day)
        case .month: return .automatic(desiredCount: 10)
        case .threeMonth: return .stride(by: .weekOfYear)
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
