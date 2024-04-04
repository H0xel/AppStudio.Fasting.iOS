//
//  WeightProgressAnalyticsView.swift
//
//
//  Created by Руслан Сафаргалеев on 02.04.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioUI

struct WeightProgressAnalyticsView: View {

    let trueWeight: WeightMeasure
    let weeklyChange: Double?
    let projection: Double?
    let weightUnits: WeightUnit

    var body: some View {
        VStack(spacing: .zero) {
            WeightProgressAnalyticsItemView(input: .trueWeight(weight: trueWeight))
            Divider()
            WeightProgressAnalyticsItemView(input: .weeklyChange(weight: weeklyChange, units: weightUnits))
            Divider()
            WeightProgressAnalyticsItemView(input: .projection(weight: projection, units: weightUnits))
        }
        .border(configuration: .init(cornerRadius: .cornerRadius,
                                     color: .studioGreyStrokeFill,
                                     lineWidth: .lineWidth))
    }
}

private extension CGFloat {
    static let lineWidth: CGFloat = 0.5
    static let cornerRadius: CGFloat = 20
}

#Preview {
    WeightProgressAnalyticsView(trueWeight: .init(value: 53.7),
                                weeklyChange: -0.08,
                                projection: 55.6,
                                weightUnits: .kg)
    .padding(.horizontal, 16)
}
