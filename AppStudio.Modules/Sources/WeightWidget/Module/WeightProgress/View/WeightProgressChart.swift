//
//  WeightProgressChart.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import Charts
import AppStudioStyles
import AppStudioModels

@available(iOS 17.0, *)
struct WeightProgressChart: View {

    let chartItems: [LineChartItem]
    let chartScale: DateChartScale
    @Binding var currentItem: Date
    @Binding var selectedDate: Date?

    var body: some View {
        LineChart(selectedDate: $selectedDate, items: chartItems, rounded: rounded)
            .frame(height: .chartHeight)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: chartScale.visibleDomain)
            .chartYScale(domain: yScaleDomain)
            .chartScrollPosition(x: .init(
                get: { currentItem.startOfTheDay.adding(.hour, value: -6) },
                set: { currentItem = $0.adding(.hour, value: 6).startOfTheDay }
            ))
            .modifier(AutomaticYAxisGridModifier(desiredCount: 5))
            .modifier(DateChartScaleModifier(chartScale: chartScale))
            .padding(.trailing, .trailingPadding)
            .onTapGesture {
                selectedDate = nil
            }
            .animation(.linear(duration: 0.2), value: yScaleDomain)
    }

    private var rounded: Bool {
        switch chartScale {
        case .month, .threeMonth: true
        case .week: false
        }
    }

    private var yScaleDomain: ClosedRange<Double> {
        let items = chartItems
            .filter { $0.currentLineWidth > 0 }
            .flatMap { $0.values }
            .filter {
                $0.label >= currentItem && 
                $0.label <= currentItem.add(days: chartScale.numberOfDays - 1)
            }

        guard let min = items.min(by: { $0.value < $1.value }),
              let max = items.max(by: { $0.value < $1.value }) else {
            return 0 ... 0
        }
        return min.value - 5 ... max.value + 5
    }
}

private extension CGFloat {
    static let chartHeight: CGFloat = 401
    static let trailingPadding: CGFloat = 12
}

#Preview {
    if #available(iOS 17.0, *) {
        WeightProgressChart(chartItems: [.scaleWeightMockLong],
                            chartScale: .month,
                            currentItem: .constant(.now), 
                            selectedDate: .constant(nil))
    } else {
        Color.white
    }
}
