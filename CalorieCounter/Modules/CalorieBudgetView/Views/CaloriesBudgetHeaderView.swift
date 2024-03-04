//
//  CaloriesBudgetHeaderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.01.2024.
//

import SwiftUI

struct CaloriesBudgetHeaderView: View {
    let goalCalories: Double
    let eatenCalories: Double

    var body: some View {
        HStack(spacing: .emptySpacing) {
            Spacer()
            CaloriesBudgetHeaderLabelView(
                calories: eatenCalories,
                title: Localization.eatenTitle,
                isLargeHeader: false
            )
            .frame(width: .labelWidth)
            Spacer()
            CaloriesBudgetHeaderRingView(
                calories: leftCalories,
                title: leftCaloriesTitle,
                trimPercent: trimPercent
            )
            Spacer()
            CaloriesBudgetHeaderLabelView(
                calories: goalCalories,
                title: Localization.goalTitle,
                isLargeHeader: false
            )
            .frame(width: .labelWidth)
            Spacer()
        }
    }

    private var leftCalories: Double {
        abs(goalCalories - eatenCalories)
    }

    private var isCaloriesOver: Bool {
        eatenCalories > goalCalories
    }

    private var leftCaloriesTitle: String {
        isCaloriesOver ? Localization.kcalOverTitle : Localization.kcalLeftTitle
    }

    private var trimPercent: CGFloat {
        goalCalories > 0 ? eatenCalories / goalCalories : 0
    }

    enum Localization {
        static let eatenTitle: String = NSLocalizedString("CaloriesBudgetHeaderView.eatenTitle",
                                                          comment: "eaten")
        static let goalTitle: String = NSLocalizedString("CaloriesBudgetHeaderView.goalTitle",
                                                         comment: "goal")
        static let kcalLeftTitle: String = NSLocalizedString("CaloriesBudgetHeaderView.kcalLeftTitle",
                                                             comment: "kcal left")
        static let kcalOverTitle: String = NSLocalizedString("CaloriesBudgetHeaderView.kcalOverTitle",
                                                             comment: "kcal over")
    }
}

private extension CGFloat {
    static let emptySpacing: CGFloat = 0.0
    static let labelWidth: CGFloat = 91.0
}

#Preview {
    VStack(spacing: 30) {
        CaloriesBudgetHeaderView(goalCalories: 2000, eatenCalories: 1200)
        CaloriesBudgetHeaderView(goalCalories: 2000, eatenCalories: 3200)
    }
    .background(.red)
}
