//  
//  FoodLogScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct FoodLogScreen: View {
    @StateObject var viewModel: FoodLogViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.studioGreyFillProgress
            VStack(spacing: .zero) {
                FoodLogNutritionProfileView(profile: viewModel.nutritionProfile,
                                            hasSubscription: viewModel.hasSubscription)
                if hasItems {
                    FoodLogScrollView(viewModel: viewModel, isFocused: isFocused)
                        .padding(.horizontal, .horizontalPadding)
                }
                Spacer()
            }
            if !hasItems {
                FoodLogEmptyView(type: viewModel.mealType)
            }
            VStack(spacing: .textFieldSpacing) {
                if canShowDoneButton {
                    LogButton {
                        viewModel.trackTapFinishLogging()
                        viewModel.dismiss()
                    }
                    .aligned(.right)
                    .padding(.trailing, .logButtonTrailingPadding)
                }
                FoodLogTextField(context: viewModel.foodLogContext,
                                 onTap: viewModel.logMeal(text:)) {
                    viewModel.trackBarcodeScannerOpen()
                    viewModel.barcodeScan()
                }
                .focused($isFocused)
            }
            .aligned(.bottom)
            if let ingredient = viewModel.tappedWeightIngredient {
                ChangeWeightTextField(title: ingredient.name,
                                      initialWeight: ingredient.weight,
                                      onWeightChange: viewModel.changeIngredientWeight,
                                      onCancel: viewModel.clearSelection)
            }

            if let meal = viewModel.tappedWeightMeal {
                ChangeWeightTextField(title: meal.mealItem.name,
                                      initialWeight: meal.mealItem.weight,
                                      onWeightChange: viewModel.changeMealWeight,
                                      onCancel: viewModel.clearSelection)
            }
        }
        .onAppear(perform: viewModel.onViewAppear)
        .onReceive(viewModel.$isKeyboardFocused) { value in
            isFocused = value
        }
        .onChange(of: isFocused, perform: viewModel.onFocusChanged)
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
        .foregroundStyle(Color.accentColor)
    }

    private var canShowDoneButton: Bool {
        !isFocused && hasItems && viewModel.mealSelectedState.isNotSelected
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
