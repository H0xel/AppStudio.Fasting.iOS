//  
//  WeightGoalUpdateScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct WeightGoalUpdateScreen: View {
    @StateObject var viewModel: WeightGoalUpdateViewModel

    var body: some View {
        VStack(spacing: .spacing) {
            Text(String.title)
                .font(.poppins(.headerS))
                .foregroundStyle(Color.studioBlackLight)
            UpdateWeightTextField(weight: $viewModel.weight,
                                  units: viewModel.weightUnits.title)
            AccentButton(title: .string(.save), 
                         action: viewModel.save)
            .padding(.horizontal, .horizontalPadding)
        }
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
    }
}

private extension String {
    static let title = "WeightGoalUpdateScreen.title".localized(bundle: .module)
    static let save = "WeightGoalUpdateScreen.save".localized(bundle: .module)
}

private extension CGFloat {
    static let spacing: CGFloat = 48
    static let topPadding: CGFloat = 32
    static let bottomPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 24
}

struct WeightGoalUpdateScreen_Previews: PreviewProvider {
    static var previews: some View {
        WeightGoalUpdateScreen(
            viewModel: WeightGoalUpdateViewModel(
                input: WeightGoalUpdateInput(weightUnits: .kg),
                output: { _ in }
            )
        )
    }
}
