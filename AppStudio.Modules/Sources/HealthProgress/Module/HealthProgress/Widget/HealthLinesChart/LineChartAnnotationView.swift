//
//  LineChartAnnotationView.swift
//
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

import SwiftUI
import AppStudioModels

struct LineChartAnnotationView: View {

    let items: [LineChartItem]

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: .annotationSpacing) {
                    item.lineColor
                        .frame(width: .lineWidth, height: item.lineWidth)
                    Text(item.title)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                }
                .aligned(.left)
            }
        }
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
    }
}

private extension CGFloat {
    static let lineWidth: CGFloat = 24
    static let lineHeight: CGFloat = 4
    static let annotationSpacing: CGFloat = 12
    static let topPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 8
}

#Preview {
    LineChartAnnotationView(items: [.scaleWeightMock, .trueWeightMock])
}
