//
//  WeightProgressChartAnnotationView.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioStyles

struct WeightProgressChartAnnotationView: View {

    let items: [LineChartItem]

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach(items.filter { !$0.title.isEmpty }) { item in
                VStack(alignment: .leading, spacing: .annotationSpacing) {
                    if item.dashed {
                        DashedLine(dashPattern: [4, 4], lineWidth: item.lineWidth)
                            .foregroundStyle(item.lineColor)
                            .frame(width: .lineWidth)
                    } else {
                        item.lineColor
                            .frame(width: .lineWidth, height: item.lineWidth)
                    }
                    Text(item.title)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                        .aligned(.left)
                }
                .padding(.top, .topPadding)
                .padding(.bottom, .bottomPadding)
                .padding(.horizontal, .horizontalPadding)
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.cornerRadius)
            }
        }
    }
}

private extension CGFloat {
    static let lineWidth: CGFloat = 28
    static let annotationSpacing: CGFloat = 12
    static let topPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 4
}

#Preview {
    WeightProgressChartAnnotationView(items: [.scaleWeightMock, .trueWeightMock])
}
