//
//  CalorieBudgetView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.01.2024.
//

import SwiftUI
import AppStudioFoundation

struct CalorieBudgetView: View {
    let dailyNorm: NutritionProfile
    let mealsEaten: [Meal]
    let hasSubscription: Bool
    var bannerData: DiscountBannerView.ViewData?
    let onSubscribeTap: () -> Void
    let bannerAction: (DiscountBannerView.Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            CaloriesBudgetHeaderView(goalCalories: dailyNorm.calories, eatenCalories: eatenCalories)
                .padding(.bottom, .headerBottomPadding)

            if let bannerData {
                DiscountBannerView(viewData: bannerData, action: bannerAction)
                    .padding(.bottom, .discountBottomPadding)
            }
            CaloriesBudgetProfilesView(dailyNormProfile: dailyNorm,
                                       currentProfile: currentProfile,
                                       hasSubscription: hasSubscription,
                                       onSubscribeTap: onSubscribeTap)
        }
    }

    private var eatenCalories: Double {
        mealsEaten.map { $0.mealItem.nutritionProfile }.total.calories
    }

    private var currentProfile: NutritionProfile {
        mealsEaten.map { $0.mealItem.nutritionProfile }.total
    }
}

private extension CGFloat {
    static let headerBottomPadding: CGFloat = 24
    static let discountBottomPadding: CGFloat = 8
}

#Preview {
    CalorieBudgetView(
        dailyNorm: NutritionProfile(calories: 1756,
                                    proteins: 84,
                                    fats: 120,
                                    carbohydrates: 90),
        mealsEaten: [
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled),
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled),
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled),
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled),
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled),
            .init(type: .dinner, dayDate: .now, mealItem: .mock, voting: .disabled)
        ],
        hasSubscription: false,
        onSubscribeTap: {},
        bannerAction: { _ in }
    )
    .padding(.vertical, 10)
    .background(.red)
}
