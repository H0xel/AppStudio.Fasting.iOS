//
//  CustomProductServingView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI
import WaterCounter

struct CustomProductServingView: View {

    let serving: MealServing
    let servingValue: Double
    let mlValue: Double?

    var body: some View {
        HStack(spacing: .spacing) {
            Text("\(servingValue.withoutDecimalsIfNeeded) \(serving.units(for: servingValue))")
            if serving.measure != MealServing.gramms.measure, let weight = serving.gramms(value: servingValue) {
                Circle()
                    .fill(Color.studioGreyPlaceholder)
                    .frame(width: .circleWidth)
                Text("\(weight.withoutDecimalsIfNeeded) \(String.gramm)")
            } else if let mlValue, serving.measure != WaterUnits.liters.unitsTitle {
                Circle()
                    .fill(Color.studioGreyPlaceholder)
                    .frame(width: .circleWidth)
                Text("\(mlValue.withoutDecimalsIfNeeded) \(WaterUnits.liters.unitsTitle)")
            }
        }
        .font(.poppins(.description))
        .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let circleWidth: CGFloat = 6
}

private extension String {
    static let gramm = "WeightUnit.gramm".localized()
}

#Preview {
    CustomProductServingView(serving: .gramms, servingValue: 75, mlValue: 2)
}
