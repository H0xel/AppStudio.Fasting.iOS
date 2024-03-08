//
//  HealthProgressBarChartView.swift
//
//
//  Created by Руслан Сафаргалеев on 05.03.2024.
//

import SwiftUI
import Charts
import AppStudioStyles

struct HealthProgressBarChartView: View {

    let title: String
    let subtitle: String
    let icon: Image
    let items: [HealthProgressBarChartItem]
    let onIconTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            HStack {
                Text(title)
                    .font(.poppinsBold(.buttonText))
                    .foregroundStyle(Color.studioBlackLight)
                Spacer()
                Button(action: onIconTap) {
                    icon
                        .padding(.trailing, .titleTrailingPadding)
                }
            }
            Text(subtitle)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioBlackLight)
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
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 4)) { _ in
                    AxisGridLine()
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
        }
        .padding(.vertical, .verticalPadding)
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
        .frame(height: .chartHeight)
    }
}

private extension CGFloat {
    static let barWidth: CGFloat = 16
    static let barCornerRadius: CGFloat = 48
    static let trailingPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 20
    static let spacing: CGFloat = 16
    static let verticalPadding: CGFloat = 20
    static let titleTrailingPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let chartHeight: CGFloat = 302
}

#Preview {
    HealthProgressBarChartView(title: "Fasting",
                               subtitle: "Last 7 days", 
                               icon: .init(.circleInfo),
                               items: HealthProgressBarChartItem.mock) {}
}
