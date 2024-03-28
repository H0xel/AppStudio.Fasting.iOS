//  
//  UpdateWeightScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine
import AppStudioModels

struct UpdateWeightScreen: View {
    @StateObject var viewModel: UpdateWeightViewModel

    var body: some View {
        VStack(spacing: .zero) {
            DateNavigationView(
                date: $viewModel.currentDate,
                dateFormat: "MMMM,yyyy",
                onPrevDayTap: { _ in },
                onNextDayTap: { _ in }
            )
            CalendarProgressView(
                viewModel: viewModel.calendarViewModel,
                style: .updateWeight
            )
            .padding(.top, .calendarTopPadding)

            if viewModel.shouldShowTodayButton {
                UpdateWeightTodayButton(onTap: viewModel.onTodayTap)
                    .padding(.top, .todayTopPadding)
                    .padding(.bottom, .todayBottomPadding)
                    .aligned(.right)
                    .padding(.horizontal, .horizontalPadding)
                    .transition(.push(from: .leading))
            }

            UpdateWeightTextField(weight: $viewModel.weight,
                                  units: viewModel.units.title)
            .padding(.bottom, .weightVerticalPadding)
            .padding(.top, viewModel.shouldShowTodayButton ? 0 : .weightVerticalPadding)

            AccentButton(title: .string(.save), action: viewModel.save)
                .padding(.horizontal, .horizontalPadding)
        }
        .animation(.bouncy, value: viewModel.shouldShowTodayButton)
        .padding(.top, .topPadding)
        .padding(.bottom, .bottomPadding)
        .background(.white)
    }
}

private extension String {
    static let save = "UpdateWeightScreen.save".localized(bundle: .module)
}

private extension CGFloat {
    static let topPadding: CGFloat = 32
    static let weightVerticalPadding: CGFloat = 48
    static let horizontalPadding: CGFloat = 24
    static let calendarTopPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 16
    static let todayTopPadding: CGFloat = 16
    static let todayBottomPadding: CGFloat = 12

}

struct UpdateWeightScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.studioGreyStrokeFill
            UpdateWeightScreen(
                viewModel: UpdateWeightViewModel(
                    input: UpdateWeightInput(date: .now, units: .kg),
                    output: { _ in }
                )
            )
            .aligned(.bottom)
        }
    }
}
