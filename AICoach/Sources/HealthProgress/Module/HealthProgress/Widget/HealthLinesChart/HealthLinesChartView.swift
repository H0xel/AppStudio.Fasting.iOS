//
//  HealthLinesChart.swift
//
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import SwiftUI
import Charts
import AppStudioUI
import AppStudioStyles
import AppStudioModels

struct HealthLinesChartView: View {

    let input: LinesChartInput
    let output: (HealthChartOutput) -> Void

    var body: some View {
        HealthProgressWidgetView(input: input.widgetInput,
                                 isEmptyState: isEmptyState,
                                 output: output) {
            VStack(spacing: .spacing) {
                Chart {
                    ForEach(input.items) { barItem in
                        ForEach(barItem.values) { value in
                            Plot {
                                LineMark(x: .value("", value.label),
                                         y: .value("", value.value),
                                         series: .value("", barItem.title))
                                .foregroundStyle(barItem.lineColor)
                                .lineStyle(.init(lineWidth: barItem.lineWidth))
                            }
                        }
                    }
                }
                .chartYScale(domain: scaleDomain())
                .chartXAxis {
                    AxisMarks(position: .bottom) { _ in
                        AxisGridLine(stroke: .init(lineWidth: .lineWidth,
                                                   lineCap: .square,
                                                   dash: [4, 4]))
                            .foregroundStyle(Color.studioGreyStrokeFill)
                        AxisValueLabel()
                            .foregroundStyle(Color.studioBlackLight)
                    }

                }
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                        AxisGridLine(stroke: .init(lineWidth: .lineWidth))
                            .foregroundStyle(Color.studioGreyStrokeFill)
                        AxisValueLabel()
                            .foregroundStyle(Color.studioBlackLight)
                    }
                }
                .frame(height: .chartHeight)
                .padding(.trailing, .trailingPadding)

                LineChartAnnotationView(items: input.items)
            }
        }
    }

    var isEmptyState: Bool {
        input.items.reduce(0) { $0 + $1.lineWidth } == 0
    }

    func scaleDomain() -> ClosedRange<Double> {
        let items = input.items.flatMap { $0.values }
        guard let min = items.min(by: { $0.value < $1.value }),
              let max = items.max(by: { $0.value < $1.value }) else {
            return 0 ... 0
        }
        return min.value - 2 ... max.value + 2
    }
}

private extension CGFloat {
    static let trailingPadding: CGFloat = 14
    static let chartHeight: CGFloat = 182
    static let spacing: CGFloat = 26
    static let lineWidth: CGFloat = 0.5
}

#Preview {
    ZStack {
        Color.red
        HealthLinesChartView(
            input: .weight(with: [.trueWeightMock, .scaleWeightMock]),
            output: { _ in }
        )
    }
}
