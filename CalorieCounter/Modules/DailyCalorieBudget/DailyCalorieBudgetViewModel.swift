//  
//  DailyCalorieBudgetViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies

enum DailyCalorieBudgetScreenMode {
    case onboarding
    case profileInfo
    case userDataChange
}

class DailyCalorieBudgetViewModel: BaseViewModel<DailyCalorieBudgetOutput> {

    @Dependency(\.trackerService) private var trackerService
    let mode: DailyCalorieBudgetScreenMode
    private let input: DailyCalorieBudgetInput

    var router: DailyCalorieBudgetRouter!

    init(mode: DailyCalorieBudgetScreenMode,
         input: DailyCalorieBudgetInput,
         output: @escaping DailyCalorieBudgetOutputBlock) {
        self.mode = mode
        self.input = input
        super.init(output: output)
        trackOnAppear()
    }

    var proteinFatCarbs: DailyCalorieBudgetChartView.ViewData {
        let budget = input.calculation.budgetInGramms
        return .init(protein: budget.proteins,
                     fat: budget.fats,
                     carbs: budget.carbohydrates,
                     calories: budget.calories)
    }

    var calorieBudget: String {
        input.calculation.budgetInGramms.calories.formattedCaloriesString
    }

    var descriptions: [DailyCalorieBudgetDescriptionView.ViewData] {
        input.descriptions
    }

    func startTapped() {
        output(.startTapped)
    }

    func prevTapped() {
        output(.backTapped)
    }

    func trackOnAppear() {
        trackerService.track(.dietPlanShown(tdee: input.calculation.totalDailyEnergyExpenditures,
                                            goal: input.goalData.calorieGoal.rawValue,
                                            calorieBudget: proteinFatCarbs.calories,
                                            p: proteinFatCarbs.protein,
                                            f: proteinFatCarbs.fat,
                                            c: proteinFatCarbs.carbs,
                                            achievementDate: input.calculation.successDate.description,
                                            proteinLevel: input.dietData.proteinLevel.analyticsValue,
                                            diet: input.dietData.dietType.analyticsValue,
                                            context: mode == .onboarding ? .onboarding : .planChange))
    }
}
