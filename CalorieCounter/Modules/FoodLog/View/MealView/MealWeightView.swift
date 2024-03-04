//
//  MealWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI

struct MealWeightView: View {

    let weight: Double
    let isTapped: Bool

    var body: some View {
        HStack(spacing: .spacing) {
            Text("\(Int(weight))")
                .foregroundStyle(.accent)
            Text(Localization.gram)
                .foregroundStyle(Color.studioGreyText)
        }
        .frame(width: .width, height: .height)
        .background(Color.studioGreyFillCard)
        .continiousCornerRadius(.cornerRadius)
        .border(configuration: .init(
            cornerRadius: .cornerRadius,
            color: .accent,
            lineWidth: isTapped ? .borderWidth : 0)
        )
    }
}

private extension CGFloat {
    static let width: CGFloat = 72
    static let height: CGFloat = 36
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
    MealWeightView(weight: 24, isTapped: true)
}
