//
//  DayFoodView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 12.04.2024.
//

import SwiftUI
import MunicornUtilities
import Combine

struct DayFoodView: View {

    @StateObject var viewModel: DayFoodViewModel
    let bannerData: DiscountBannerView.ViewData?
    private let viewHeight = screenHeight * 0.7

    var body: some View {
        ScrollView {
            Spacer(minLength: calendarTotalHeight + UIDevice.safeAreaTopInset)
            VStack(spacing: .mealTypeBottomPadding) {
                CalorieBudgetView(dailyNorm: viewModel.profile,
                                  mealsEaten: viewModel.meals,
                                  hasSubscription: viewModel.hasSubscription,
                                  bannerData: bannerData,
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

                ForEach(viewModel.mealRecords, id: \.type) { record in
                    MealTypeView(record: record,
                                 hasSubscription: viewModel.hasSubscription,
                                 onAddMealTap: { record in
                        viewModel.trackTapAddFood(type: record.type, context: .foodLog)
                        viewModel.presentFoodLogScreen(mealType: record.type, context: .input)
                    }, onCardType: { record in
                        viewModel.trackTapOpenContainer(type: record.type)
                        viewModel.presentFoodLogScreen(mealType: record.type, context: .view)
                    })
                }
                Spacer(minLength: .bottomSpacing)
            }
            .padding(.horizontal, .horizontalPadding)
            .background(
                ZStack {
                    horizontalGradient
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
            horizontalGradient
                .frame(height: calendarTotalHeight + UIDevice.safeAreaTopInset)
                .aligned(.top)
        )
        .background(
            VStack(spacing: .zero) {
                horizontalGradient
                Color.studioGreyFillProgress
            }
        )
        .ignoresSafeArea()
    }

    private var verticalGradient: some View {
        LinearGradient(stops: [.init(color: .clear, location: 0),
                               .init(color: .studioGreyFillProgress, location: 0.8)],
                       startPoint: .top,
                       endPoint: .bottom)
    }

    private var horizontalGradient: some View {
        let colors = backgroundColors
        return LinearGradient(stops: [
            .init(color: colors[0], location: 0),
            .init(color: colors[1], location: 0.5)],
                              startPoint: .leading,
                              endPoint: .trailing)
    }

    private var backgroundColors: [Color] {
        let value = viewModel.caloriesLeftValue
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
        .calendarHeight + .calendarTopPadding + .calendarBottomPadding + .navBarHeight
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let mealTypeBottomPadding: CGFloat = 8
    static let caloriesBudgetTopPadding: CGFloat = 8
    static let bottomSpacing: CGFloat = 114
    static let calendarHeight: CGFloat = 61
    static let calendarBottomPadding: CGFloat = 16
    static let calendarTopPadding: CGFloat = 8
    static let navBarHeight: CGFloat = 44
}

#Preview {
    DayFoodView(viewModel: .init(
        input: .init(
            date: .now,
            router: .init(navigator: .init()),
            focusTextFieldPublisher: Just((.now, .input)).eraseToAnyPublisher(),
            foodLogPublisher: Just((.now, .lunch)).eraseToAnyPublisher(),
            updateProfilePublisher: Just(()).eraseToAnyPublisher()),
        output: { _ in }),
                bannerData: .mock)
}
