//
//  FastingHistoryChart.swift
//
//
//  Created by Amakhin Ivan on 19.03.2024.
//

import SwiftUI
import Charts
import AppStudioStyles
import AppStudioModels

@available(iOS 17.0, *)
struct FastingHistoryChart: View {
    @Binding var selectedItem: FastingHistoryChartItem?
    let context: FastingHistoryInput.Context
    let initialPosition: Date
    let selectedPeriod: GraphPeriod
    let items: [FastingHistoryChartItem]
    var scrollDate: (Date) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {

            Chart(items) { barItem in
                Plot {
                    BarMark(
                        x: .value("", barItem.date, unit: selectedPeriod.unit),
                        y: .value("", barItem.value),
                        width: .fixed(selectedPeriod.fastingHistoryBarWidth),
                        stacking: .unstacked
                    )
                    .foregroundStyle(
                        HistoryGraphShapeStyle(barItem: barItem,
                                               selectedPeriod: selectedPeriod,
                                               items: items)
                    )
                    .clipShape(RoundedRectangle(
                        cornerRadius: .barCornerRadius,
                        style: .continuous)
                    )

                    LineMark(
                        x: .value("", barItem.date, unit: selectedPeriod.unit),
                        y: .value("", barItem.lineValue)
                    )
                    .lineStyle(.init(lineCap: .square, dash: [7, 7]))
                    .foregroundStyle(Color.studioBlackLight)
                    .interpolationMethod(.stepCenter)
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartScrollPosition(x: .constant(initialPosition))
            .chartXVisibleDomain(length: .secondsIn24Hours * selectedPeriod.fastingHistoryVisibleDomain)
            .chartXAxis {
                AxisMarks(preset: .automatic, values: selectedPeriod.xValuesAmount) { value in
                    AxisValueLabel(format: selectedPeriod.format)
                        .foregroundStyle(Color.studioBlackLight)
                        .offset(x: selectedPeriod.fastingChartXOffset)
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: context.yAxisStride)) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    guard let element = findElement(location: value.location, proxy: proxy, geometry: geo),
                                          element.value != 0 else {
                                        return
                                    }
                                    if selectedItem?.date == element.date {
                                        // If tapping the same element, clear the selection.
                                        selectedItem = nil
                                    } else {
                                        selectedItem = element
                                    }
                                }
                        )
                }
            }
            .chartBackground { proxy in
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo[proxy.plotAreaFrame].origin.x) { width in
                                guard width < 0 else { return }
                                if let date = proxy.value(atX: abs(width)) as Date? {
                                    var minDistance: TimeInterval = .infinity
                                    var index: Int? = nil
                                    for salesDataIndex in self.items.indices {
                                        let nthSalesDataDistance = items[salesDataIndex].date.distance(to: date)
                                        if abs(nthSalesDataDistance) < minDistance {
                                            minDistance = abs(nthSalesDataDistance)
                                            index = salesDataIndex
                                        }
                                    }

                                    if let index {
                                        scrollDate(items[index].date)
                                    }
                                }
                            }

                        if let selectedItem {
                            let dateInterval = Calendar.current.dateInterval(of: selectedPeriod.unit, for: selectedItem.date)!
                            let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0

                            let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                            let lineHeight = geo[proxy.plotAreaFrame].maxY

                            Rectangle()
                                .fill(.black)
                                .frame(width: 1, height: lineHeight)
                                .position(x: lineX + selectedPeriod.fastingHistoryOffset, y: lineHeight / 2)
                        }
                    }
                }
            }

            HStack(spacing: .descriptionSpacing) {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: .lineHeight, dash: [4]))
                    .frame(width: .lineWidth, height: .lineHeight)
                Text(context.graphDescription)
                    .font(.poppins(.description))
            }
            .aligned(.centerHorizontaly)
        }
        .padding(.vertical, .verticalPadding)
        .padding(.trailing, .trailingPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
        .frame(height: .chartHeight)
    }

    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> FastingHistoryChartItem? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in items.indices {
                let nthSalesDataDistance = items[salesDataIndex].date.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index {
                return items[index]
            }
        }
        return nil
    }

}

private extension CGFloat {
    static let barWidth: CGFloat = 16
    static let barCornerRadius: CGFloat = 48
    static let spacing: CGFloat = 16
    static let verticalPadding: CGFloat = 20
    static let titleTrailingPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let chartHeight: CGFloat = 410
    static let lineWidth: CGFloat = 30
    static let lineHeight: CGFloat = 1
    static let descriptionSpacing: CGFloat = 8
    static let trailingPadding: CGFloat = 12
}

private extension Int {
    static let secondsIn24Hours: Int = 86400
}

@available(iOS 17.0, *)
#Preview {
    FastingHistoryChart(selectedItem: .constant(.mock), 
                        context: .water(.ounces),
                        initialPosition: .now,
                        selectedPeriod: .threeMonths,
                        items: .mock) { _ in }
}
