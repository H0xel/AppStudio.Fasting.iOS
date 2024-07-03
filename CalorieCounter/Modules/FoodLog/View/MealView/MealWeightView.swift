//
//  MealWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI
import AppStudioStyles

struct MealWeightView: View {

    let weight: Double
    let serving: MealServing
    let isTapped: Bool

    var body: some View {
        HStack(spacing: .spacing) {
            Text(serving == .gramms ? "\(String(format: "%.0f", weight))" : weight.withoutDecimalsIfNeeded)
                .foregroundStyle(.accent)
            Text(serving.units(for: weight))
                .foregroundStyle(Color.studioGreyText)
        }
        .font(.poppins(.description))
        .frame(width: .width, height: .height)
        .background(Color.studioGreyFillProgress)
        .continiousCornerRadius(.cornerRadius)
        .border(configuration: .init(
            cornerRadius: .cornerRadius,
            color: .accent,
            lineWidth: isTapped ? .borderWidth : 0)
        )
    }
}

private extension CGFloat {
    static let width: CGFloat = 80
    static let height: CGFloat = 32
    static let cornerRadius: CGFloat = 8
    static let spacing: CGFloat = 4
    static let borderWidth: CGFloat = 2
}

private extension MealWeightView {
    enum Localization {
        static let gram: LocalizedStringKey = "Ingredient.weightLabel"
    }
}

#Preview {
    MealWeightView(weight: 24, serving: .gramms, isTapped: true)
}
