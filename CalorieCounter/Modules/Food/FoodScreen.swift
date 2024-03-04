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
    @State private var viewHeight: CGFloat = screenHeight * 0.7
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        TabView(selection: $viewModel.currentDay) {
            ForEach(viewModel.displayDays, id: \.self) { day in
                ScrollView {
                    VStack(spacing: .mealTypeBottomPadding) {
                        Spacer(minLength: calendarTotalHeight + UIDevice.safeAreaTopInset)
                        CalorieBudgetView(dailyNorm: viewModel.calorieBudget(for: day),
                                          mealsEaten: viewModel.meals(for: day),
                                          hasSubscription: viewModel.hasSubscription,
                                          bannerData: .init(hasSubscription: viewModel.hasSubscription,
                                                            discountPaywallInfo: viewModel.discountPaywallInfo,
                                                            timerInterval: viewModel.timerInterval),
                                          onSubscribeTap: viewModel.subscribeTap,
                                          bannerAction: { action in
                            switch action {
                            case .close:
                                viewModel.closeBannerTapped()
                            case .openPaywall:
                                viewModel.bannerTapped()
                            }}
                        )
                        .padding(.top, .caloriesBudgetTopPadding)
                        .animation(.linear, value: viewModel.currentDay)
                        .animation(.linear, value: viewModel.tabViewId)

                        ForEach(viewModel.records(for: day), id: \.type) { record in
                            MealTypeView(record: record,
                                         hasSubscription: viewModel.hasSubscription,
                                         onAddMealTap: { record in
                                viewModel.trackTapAddFood(type: record.type,
                                                          context: .foodLog)
                                viewModel.addMeal(type: record.type, context: .input)
                            }, onCardType: { record in
                                viewModel.trackTapOpenContainer(type: record.type)
                                viewModel.addMeal(type: record.type, context: .view)
                            })
                        }
                        Spacer(minLength: .bottomSpacing)
                    }
                    .padding(.horizontal, .horizontalPadding)
                    .background(
                        ZStack {
                            horizontalGradient(for: day)
                            VStack(spacing: .zero) {
                                Spacer(minLength: calendarTotalHeight + UIDevice.safeAreaTopInset)
                                verticalGradient
                                    .frame(height: viewHeight)
                                Color.studioGreyFillProgress
                            }
                        }
                    )
                }
                .scrollIndicators(.hidden)
                .overlay(
                    horizontalGradient(for: day)
                        .frame(height: calendarTotalHeight + UIDevice.safeAreaTopInset)
                        .aligned(.top)
                )
                .ignoresSafeArea()
                .environment(\.isCurrentTab, day == viewModel.currentDay)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .environment(\.id, viewModel.tabViewId)
        .background(
            VStack(spacing: .zero) {
                horizontalGradient(for: viewModel.currentDay)
                Color.studioGreyFillProgress
            }
        )
        .ignoresSafeArea()
        .overlay(
            TabView(selection: $viewModel.currentWeek) {
                ForEach(viewModel.displayWeeks, id: \.self) { week in
                    FoodCalendarView(selectedDate: viewModel.currentDay,
                                     dayProgress: viewModel.weekProgress(week: week),
                                     onTap: viewModel.selectDate)
                    .padding(.horizontal, .horizontalPadding)
                    .background(.white.opacity(0.01))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: .calendarHeight)
            .padding(.bottom, .calendarBottomPadding)
            .padding(.top, .calendarTopPadding)
            .aligned(.top)
        )
        .onAppear {
            viewModel.presentTextField(isFocused: false)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.updateTimer()
            }
        }
    }

    private func horizontalGradient(for day: Date) -> some View {
        let colors = backgroundColors(for: day)
        return LinearGradient(stops: [
            .init(color: colors[0], location: 0),
            .init(color: colors[1], location: 0.5)],
                              startPoint: .leading,
                              endPoint: .trailing)
    }

    private var verticalGradient: some View {
        LinearGradient(stops: [.init(color: .clear, location: 0),
                               .init(color: .studioGreyFillProgress, location: 0.8)],
                       startPoint: .top,
                       endPoint: .bottom)
    }

    private func backgroundColors(for day: Date) -> [Color] {
        let value = viewModel.caloriesLeftValue(for: day)
        if value <= 0.25 {
            return [.studioOrange, .studioGreen]
        }
        if value <= 0.5 {
            return [.studioGreen, .studioSky]
        }
        if value <= 0.75 {
            return [.studioSky, .studioBlue]
        }
        if value <= 1 {
            return [.studioBlue, .studioPurple]
        }
        return [.studioPurple, .studioRed]
    }

    private var calendarTotalHeight: CGFloat {
        .calendarHeight + .calendarTopPadding + .calendarBottomPadding
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
            input: FoodInput(presentFoodLogPublisher: Just(.lunch).eraseToAnyPublisher(),
                             profileUpdatePublisher: Just(()).eraseToAnyPublisher()),
            output: { _ in }
        )

        viewModel.router = .init(navigator: Navigator())

        return FoodScreen(
            viewModel: viewModel
        )
    }
}
