//
//  FoodLogScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Combine
import AVFoundation

struct FoodLogScreen: View {
    @StateObject var viewModel: FoodLogViewModel

    var body: some View {
        ZStack {
            Color.studioGreyFillProgress
            VStack(spacing: .zero) {
                FoodLogNutritionProfileView(profile: viewModel.nutritionProfile,
                                            hasSubscription: viewModel.hasSubscription)
                if viewModel.hasSubscription {
                    FoodLogCalorieBudgetView(profile: viewModel.nutritionProfile)
                }
                if hasItems {
                    FoodLogScrollView(viewModel: viewModel)
                        .padding(.horizontal, .horizontalPadding)
                }
                Spacer()
            }
            if !hasItems {
                FoodLogEmptyView(type: viewModel.mealType)
            }

            FoodLogInputView(isPresented: !viewModel.isBannerPresented, viewModel: viewModel.inputViewModel)
                .aligned(.bottom)
                .opacity(viewModel.isBannerPresented ? 0 : 1)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(placement: .principal,
                      content: navigationTitleView,
                      action: viewModel.changeMealType)
        .navBarButton(content: Image.chevronLeft) {
            viewModel.trackTapBackButton()
            viewModel.dismiss()
        }
        .toolbar(.visible, for: .navigationBar)
    }

    private var navigationTitleView: some View {
        HStack(spacing: .navBarSpacing) {
            Text(viewModel.mealType.title)
                .font(.poppins(.buttonText))
            Image.chevronDown
                .font(.system(size: .backButtonFontSize, weight: .medium))
        }
        .foregroundStyle(Color.studioBlackLight)
    }

    private var hasItems: Bool {
        !viewModel.logItems.isEmpty
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let navBarSpacing: CGFloat = 8
    static let backButtonFontSize: CGFloat = 14
    static let horizontalPadding: CGFloat = 16
    static let textFieldSpacing: CGFloat = 12
    static let logButtonTrailingPadding: CGFloat = 20
    static let bottomPadding: CGFloat = 8
    static let horizontalChipsPadding: CGFloat = 10
    static let doneButtonOffset: CGFloat = -80
}

struct FoodLogScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            FoodLogScreen(
                viewModel: FoodLogViewModel(
                    input: FoodLogInput(mealType: .breakfast,
                                        dayDate: .now.startOfTheDay,
                                        context: .input,
                                        initialMeal: [],
                                        hasSubscription: false,
                                        mealsCountInDay: 0),
                    output: { _ in }
                )
            )
        }
    }
}
