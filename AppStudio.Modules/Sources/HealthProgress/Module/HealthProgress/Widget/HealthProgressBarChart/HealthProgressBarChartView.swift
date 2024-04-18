//
//  HealthProgressBarChartView.swift
//
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
//

import SwiftUI
import Charts
import AppStudioStyles
import AppStudioModels

struct HealthProgressBarChartView: View {

    let widgetInput: HealthWidgetInput
    let items: [HealthProgressBarChartItem]
    let isMonetization: Bool
    let output: (HealthChartOutput) -> Void

    var body: some View {
        HealthProgressWidgetView(input: widgetInput,
                                 isEmptyState: isEmptyState, 
                                 isMonetization: isMonetization,
                                 output: output) {
            Chart {
                ForEach(items) { barItem in
                    Plot {
                        BarMark(
                            x: .value("", barItem.label),
                            y: .value("", barItem.value),
                            width: .fixed(.barWidth)
                        )
                        .foregroundStyle(barItem.color)
                        .clipShape(RoundedRectangle(
                            cornerRadius: .barCornerRadius,
                            style: .continuous)
                        )
                        LineMark(
                            x: .value("", barItem.label),
                            y: .value("", barItem.lineValue)
                        )
                        .lineStyle(.init(lineCap: .square, dash: [4, 4]))
                        .foregroundStyle(Color.studioBlackLight)
                        .interpolationMethod(.stepCenter)
                    }
                }
            }
            .chartYScale(domain: scaleDomain())
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 6)) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
            .padding(.leading, .leadingPadding)
            .padding(.trailing, .trailingPadding)
        }
        .frame(height: height)
    }

    private var isEmptyState: Bool {
        if isMonetization {
            return false
        }
        return items.reduce(0) { $0 + $1.value } == 0
    }

    private var height: CGFloat {
        if isMonetization {
            return .chartHeightMonetization
        }
        return isEmptyState ? .chartHeightEmptyState : .chartHeight
    }

    func scaleDomain() -> ClosedRange<Double> {
        let maxValue = items.max(by: { $0.value < $1.value })
        let maxLineValue = items.max(by: { $0.lineValue < $1.lineValue })
        if let maxValue = maxValue?.value, let maxLineValue = maxLineValue?.lineValue {
            let max = max(maxValue, maxLineValue)
            let upperBound = max > 0 ? max : 20
            return 0 ... upperBound
        }
        return 0 ... 20
    }
}

private extension CGFloat {
    static let barWidth: CGFloat = 16
    static let barCornerRadius: CGFloat = 48
    static let trailingPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 20
    static let chartHeight: CGFloat = 302
    static let chartHeightMonetization: CGFloat = 350
    static let chartHeightEmptyState: CGFloat = 402
    static let exploreButtonSpacing: CGFloat = 12
}

#Preview {
    HealthProgressBarChartView(widgetInput: .weight,
                               items: [], 
                               isMonetization: true) { _ in }
}
