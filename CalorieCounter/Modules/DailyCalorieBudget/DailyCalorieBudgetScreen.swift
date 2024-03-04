//  
//  DailyCalorieBudgetScreen.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct DailyCalorieBudgetScreen: View {
    @StateObject var viewModel: DailyCalorieBudgetViewModel

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    DailyCalorieBudgetTitleView(kcal: viewModel.calorieBudget)

                    DailyCalorieBudgetChartView(
                        viewData: viewModel.proteinFatCarbs,
                        width: proxy.size.width
                    )

                    ForEach(viewModel.descriptions) { viewData in
                        DailyCalorieBudgetDescriptionView(viewData: viewData)
                    }

                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 6)
                }
            }
            .padding(.horizontal, .horizontalPadding)

            switch viewModel.mode {
            case .onboarding:
                DailyCalorieBudgetButtonsView(startButtonTitle: .next,
                                              onPrevTap: viewModel.prevTapped,
                                              onStartTap: viewModel.startTapped)
            case .profileInfo:
                DailyCalorieBudgetButtonsView(startButtonTitle: .okTitle,
                                              onPrevTap: nil,
                                              onStartTap: viewModel.startTapped)
            case .userDataChange:
                DailyCalorieBudgetButtonsView(startButtonTitle: .okTitle,
                                              onPrevTap: viewModel.prevTapped,
                                              onStartTap: viewModel.startTapped)
            }
        }
        .navBarButton(isVisible: viewModel.mode == .profileInfo,
                      content: Image.xmark.foregroundStyle(.accent),
                      action: viewModel.startTapped)
        .navBarButton(placement: .principal,
                      isVisible: viewModel.mode == .profileInfo,
                      content: Text(.profileInfoTitle).font(.poppins(.buttonText)).foregroundStyle(.accent),
                      action: {})
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension LocalizedStringKey {
    static let next: LocalizedStringKey = "NextTitle"
    static let okTitle: LocalizedStringKey = "OkTitle"
    static let profileInfoTitle: LocalizedStringKey = "DailyCalorieBudget.profileInfoTitle"
}

private extension CGFloat {
    static var horizontalPadding: CGFloat { 16 }
}

struct DailyCalorieBudgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        DailyCalorieBudgetScreen(
            viewModel: DailyCalorieBudgetViewModel(
                mode: .onboarding,
                input: .mock,
                output: { _ in }
            )
        )
    }
}
