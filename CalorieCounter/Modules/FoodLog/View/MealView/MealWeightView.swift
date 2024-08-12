//
//  MealWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI
import AppStudioStyles

struct MealWeightView: View {
    let type: MealWeightType
    let serving: MealServing
    let isTapped: Bool
    let withoutDecimalIfNeeded: Bool
    let weightColor: Color
    let width: CGFloat

    init(type: MealWeightType,
         serving: MealServing,
         isTapped: Bool,
         withoutDecimalIfNeeded: Bool = false,
         weightColor: Color = Color.studioBlackLight,
         width: CGFloat = .width) {
        self.type = type
        self.serving = serving
        self.withoutDecimalIfNeeded = withoutDecimalIfNeeded
        self.weightColor = weightColor
        self.isTapped = isTapped
        self.width = width
    }

    var body: some View {
        HStack(spacing: .spacing) {
            switch type {
            case .text(let string):
                Text(string)
                    .foregroundStyle(weightColor)
            case .weight(let weight):
                Text(convertedWeight(weight: weight))
                    .foregroundStyle(weightColor)
                Text(serving.units(for: weight))
                    .foregroundStyle(Color.studioGreyText)
            }
        }
        .font(.poppins(.description))
        .frame(width: width, height: .height)
        .background(Color.studioGreyFillProgress)
        .continiousCornerRadius(.cornerRadius)
        .border(configuration: .init(
            cornerRadius: .cornerRadius,
            color: .accent,
            lineWidth: isTapped ? .borderWidth : 0)
        )
    }

    private func convertedWeight(weight: Double) -> String {
        if withoutDecimalIfNeeded {
            return weight.withoutDecimalsIfNeeded
        }
        return serving == .gramms
        ? "\(String(format: "%.0f", weight))"
        : weight.withoutDecimalsIfNeeded
    }
}

extension MealWeightView {
    enum MealWeightType {
        case text(String)
        case weight(Double)
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
    MealWeightView(type: .weight(24), serving: .gramms, isTapped: true)
}
