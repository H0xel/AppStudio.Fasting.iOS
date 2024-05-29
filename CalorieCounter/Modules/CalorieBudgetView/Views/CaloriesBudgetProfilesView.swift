//
//  CaloriesBudgetProfilesView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.01.2024.
//

import SwiftUI

struct CaloriesBudgetProfilesView: View {
    let dailyNormProfile: NutritionProfile
    let currentProfile: NutritionProfile
    let hasSubscription: Bool
    let onSubscribeTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            if !hasSubscription {
                Text(.macros)
                    .font(.poppins(.headerS))
                    .padding(.bottom, .macrosBottomPadding)
            }
            HStack(spacing: .emptySpacing) {
                Spacer()
                CaloriesBudgetProfilesCell(type: .fats,
                                           value: currentProfile.fats,
                                           total: dailyNormProfile.fats)
                Spacer(minLength: .horizontalPadding)
                CaloriesBudgetProfilesCell(type: .carbs,
                                           value: currentProfile.carbohydrates,
                                           total: dailyNormProfile.carbohydrates)
                Spacer(minLength: .horizontalPadding)
                CaloriesBudgetProfilesCell(type: .proteins,
                                           value: currentProfile.proteins,
                                           total: dailyNormProfile.proteins)
                Spacer()
            }
            .blur(radius: hasSubscription ? 0 : 4)
            if !hasSubscription {
                GetPlusButton(onTap: onSubscribeTap)
                    .padding(.top, .buttonTopPadding)
            }
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.top, .verticalPadding)
        .padding(.bottom, hasSubscription ? .verticalPadding : .noSubscriptionBottomPadding)
        .background {
            RoundedRectangle(cornerRadius: .cornerRadius)
                .foregroundStyle(.white)
        }
    }
}

private extension LocalizedStringKey {
    static let macros: LocalizedStringKey = "FoodScreen.macros"
}

private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let verticalPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let buttonTopPadding: CGFloat = 16
    static let macrosBottomPadding: CGFloat = 16
    static let noSubscriptionBottomPadding: CGFloat = 28
}

#Preview {
    ZStack {
        Color.red
        CaloriesBudgetProfilesView(dailyNormProfile: .empty,
                                   currentProfile: .empty,
                                   hasSubscription: false) {}
    }
}
