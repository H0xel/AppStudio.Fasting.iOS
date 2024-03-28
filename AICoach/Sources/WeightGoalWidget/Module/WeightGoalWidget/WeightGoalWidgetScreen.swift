//  
//  WeightGoalWidgetScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine

struct WeightGoalWidgetScreen: View {
    @StateObject var viewModel: WeightGoalWidgetViewModel

    var body: some View {
        VStack(spacing: .spacing) {
            WidgetTitleView(title: title,
                            icon: .init(.widgetSettings),
                            onTap: viewModel.presentGoalUpdate)
            HStack(spacing: .zero) {
                WeightValueView(title: .trueWeight,
                                weight: viewModel.currentWeight,
                                isBig: true)
                .aligned(.left)
                WeightValueView(title: daysIn,
                                weight: viewModel.progress,
                                isBig: true,
                                colorForNegativeNumbers: .studioGreen)
                .aligned(.left)
            }
            if hasSuccess {
                WeightGoalSuccessView()
            }
            if hasOverweight {
                WeightGoalOverweightView()
            }
            WeightGoalProgressView(startWeight: viewModel.startWeight,
                                   goalWeight: viewModel.goalWeight,
                                   currentWeight: viewModel.currentWeight)
        }
        .modifier(WidgetModifier())
        .onAppear {
            viewModel.updateGoal()
        }
    }

    private var hasOverweight: Bool {
        viewModel.currentWeight.normalizeValue > viewModel.startWeight.normalizeValue
    }

    private var hasSuccess: Bool {
        viewModel.currentWeight.normalizeValue <= viewModel.goalWeight.normalizeValue
    }

    private var title: String {
        "\(String.goal): \(viewModel.goalWeight.valueWithSingleDecimalInNeeded)"
    }

    private var daysIn: String {
        let numberOfDays = viewModel.daysSinceStart
        let title = numberOfDays > 1 ? String.daysIn : .dayIn
        return "\(numberOfDays) \(title)"
    }
}

private extension String {
    static let trueWeight = "WeightGoalWidgetScreen.trueWeight".localized(bundle: .module)
    static let goal = "WeightGoalWidgetScreen.goal".localized(bundle: .module)
    static let daysIn = "WeightGoalWidgetScreen.daysIn".localized(bundle: .module)
    static let dayIn = "WeightGoalWidgetScreen.dayIn".localized(bundle: .module)
}

private extension CGFloat {
    static let padding: CGFloat = 20
    static let spacing: CGFloat = 16
}

struct WeightGoalWidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            WeightGoalWidgetScreen(
                viewModel: WeightGoalWidgetViewModel(
                    input: WeightGoalWidgetInput(
                        currentWeightPublisher: Just(.init(value: 100)).eraseToAnyPublisher()
                    ),
                    output: { _ in }
                )
            )
        }
    }
}
