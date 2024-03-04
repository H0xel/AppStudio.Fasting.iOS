//
//  FoodLogNutritionProfileView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI

struct FoodLogNutritionProfileView: View {

    let profile: NutritionProfile
    let hasSubscription: Bool

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(NutritionType.allCases, id: \.self) { type in
                NutritionView(
                    amount: profile.amount(for: type),
                    configuration: configuration(for: type),
                    bordered: false
                )
                if type != .carbs {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, .horizoltalPadding)
        .padding(.vertical, .verticalPadding)
        .background(.white)
    }

    private func configuration(for type: NutritionType) -> NutritionView.Configuration {
        guard hasSubscription || type == .calories else {
            return .hidden(type: type)
        }
        return profile == .empty ? .greyStrokeLarge(type: type) : .coloredLarge(type: type)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let horizoltalPadding: CGFloat = 48
    static let verticalPadding: CGFloat = 16
}

#Preview {
    ZStack {
        Color.red
        FoodLogNutritionProfileView(profile: .init(calories: 0,
                                                   proteins: 0,
                                                   fats: 0,
                                                   carbohydrates: 0),
                                    hasSubscription: false)
    }
}
