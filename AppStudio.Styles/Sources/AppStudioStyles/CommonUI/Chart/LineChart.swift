//
//  LineChart.swift
//  
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import Charts
import AppStudioModels

public struct LineChart: View {

    @Binding private var selectedDate: Date?
    private let items: [LineChartItem]
    private let rounded: Bool
    @State private var currentSelectedDate: Date?

    public init(selectedDate: Binding<Date?>, items: [LineChartItem], rounded: Bool = false) {
        self._selectedDate = selectedDate
        self.items = items
        self.rounded = rounded
    }

    public var body: some View {
        Chart {
            Plot {
                ForEach(items) { item in
                    ForEach(item.values) { value in
                        if value.value > 0 {
                            LineMark(x: .value("", value.label),
                                     y: .value("", value.value),
                                     series: .value("", item.title))
                            .foregroundStyle(item.lineColor)
                            .lineStyle(.init(lineWidth: item.lineWidth,
                                             dash: item.dashed ? [4, 4] : []))
                            .interpolationMethod(interpolationMethod(for: item))
                        }
                    }
                }
                if let selectedDate {
                    RuleMark(x: .value("", selectedDate))
                }
            }
        }
        .chartXSelectionIfAvailable(value: $currentSelectedDate)
        .onChange(of: currentSelectedDate) { newValue in
            if let newValue {
                selectedDate = newValue
            }
        }
    }

    private func interpolationMethod(for item: LineChartItem) -> InterpolationMethod {
        if item.dashed {
            return .stepCenter
        }
        return rounded ? .cardinal : .linear
    }
}

private extension View {
    @ViewBuilder
    func chartXSelectionIfAvailable(value: Binding<Date?>) -> some View {
        if #available(iOS 17.0, *) {
            self.chartXSelection(value: value)
        } else {
            self
        }
    }
}

#Preview {
    LineChart(selectedDate: .constant(nil), items: [.trueWeightMock, .scaleWeightMock])
        .frame(height: 400)
}
