//
//  MealNutritionProfileView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI

struct MealNutritionProfileView: View {

    let profile: NutritionProfile
    let canShowNutritions: Bool

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach(NutritionType.allCases, id: \.self) { type in
                NutritionView(amount: profile.amount(for: type),
                              configuration: configuration(for: type),
                              bordered: true)
            }
        }
    }

    private func configuration(for type: NutritionType) -> NutritionView.Configuration {
        guard canShowNutritions || type == .calories else {
            return .hiddenSmall(type: type)
        }
        return .coloredSmall(type: type)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
}

#Preview {
    MealNutritionProfileView(profile: .empty, canShowNutritions: false)
}
