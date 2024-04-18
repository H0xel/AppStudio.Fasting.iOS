//  
//  FoodScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import SwiftUI
import AppStudioNavigation
import MunicornUtilities
import AppStudioUI
import Combine
import AppStudioStyles

struct FoodScreen: View {
    @StateObject var viewModel: FoodViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            SwipeDaysView(viewModel: viewModel.swipeDaysViewModel) { tabDate, currentDate  in
                DayFoodView(
                    viewModel: .init(input: viewModel.dayFoodInput(date: tabDate),
                                     output: viewModel.handle),
                    bannerData: .init(hasSubscription: viewModel.hasSubscription,
                                      discountPaywallInfo: viewModel.discountPaywallInfo,
                                      timerInterval: viewModel.timerInterval)
                )
            }
            .ignoresSafeArea()
            FoodNavigationView(calendarViewModel: viewModel.calendarViewModel,
                               swipeDaysViewModel: viewModel.swipeDaysViewModel,
                               onProfileTap: viewModel.presentProfile,
                               onPrevDayTap: viewModel.trackPrevDay,
                               onNextDayTap: viewModel.trackNextDay)
            .aligned(.top)
        }
        .background(Color.studioGreyFillProgress)
        .onAppear {
            viewModel.presentTextField(isFocused: false)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if let paywallInfo = viewModel.discountPaywallInfo {
                    viewModel.updateTimer(discountPaywallInfo: paywallInfo)
                }
            }
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let mealTypeBottomPadding: CGFloat = 8
    static let calendarHeight: CGFloat = 61
    static let calendarBottomPadding: CGFloat = 16
    static let caloriesBudgetTopPadding: CGFloat = 8
    static let bottomSpacing: CGFloat = 114
    static let calendarTopPadding: CGFloat = 8
}

// MARK: - Localization
private extension FoodScreen {
    enum Localization {
        static let title: LocalizedStringKey = "FoodScreen"
    }
}

struct FoodScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FoodViewModel(
            input: FoodInput(presentFoodLogPublisher: Just(.lunch).eraseToAnyPublisher()),
            output: { _ in }
        )

        viewModel.router = .init(navigator: Navigator())

        return FoodScreen(
            viewModel: viewModel
        )
    }
}
