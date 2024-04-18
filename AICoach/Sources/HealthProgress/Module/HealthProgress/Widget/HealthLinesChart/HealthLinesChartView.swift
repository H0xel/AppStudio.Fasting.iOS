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
    let isMonetization: Bool
    let output: (HealthChartOutput) -> Void

    var body: some View {
        HealthProgressWidgetView(input: input.widgetInput,
                                 isEmptyState: input.isEmpty, 
                                 isMonetization: isMonetization,
                                 output: output) {
            VStack(spacing: .spacing)  {
                LineChart(selectedDate: .constant(nil), items: input.items)
                    .chartYScale(domain: input.yScaleDomain)
                    .modifier(VerticalDashedGridModifier())
                    .modifier(AutomaticYAxisGridModifier(desiredCount: 5))
                    .frame(height: .chartHeight)
                    .padding(.trailing, .trailingPadding)
                LineChartAnnotationView(items: input.items)
                    .padding(.horizontal, .horizontalPadding)
            }
        }
    }
}

private extension CGFloat {
    static let trailingPadding: CGFloat = 14
    static let chartHeight: CGFloat = 182
    static let spacing: CGFloat = 16
    static let lineWidth: CGFloat = 0.5
    static let horizontalPadding: CGFloat = 20
}

#Preview {
    ZStack {
        Color.red
        HealthLinesChartView(
            input: .weight(with: [.trueWeightMock, .scaleWeightMock]), 
            isMonetization: false,
            output: { _ in }
        )
    }
}
