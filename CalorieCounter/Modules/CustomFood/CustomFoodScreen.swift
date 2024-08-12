//  
//  CustomFoodScreen.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct CustomFoodScreen: View {
    @StateObject var viewModel: CustomFoodViewModel

    var body: some View {
        VStack(spacing: .zero) {
            FoodLogNutritionProfileView(
                profile: viewModel.normalizedProfile,
                hasSubscription: true
            )
            .padding(.top, .profileDecreaseTopPadding)
            .padding(.bottom, .profileDecreaseBottomPadding)

            if viewModel.canShowBudgetView {
                FoodLogCalorieBudgetView(profile: viewModel.normalizedProfile)
            }

            CustomFoodScrollView(viewModel: viewModel)
        }
        .onTapGesture {
            viewModel.clear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(placement: .principal,
                      content: navigationTitleView,
                      action: {})
        .navBarButton(content: Image.xmarkUnfilled
            .resizable()
            .frame(width: .closeButtonFrame, height: .closeButtonFrame)
            .foregroundStyle(Color.studioBlackLight)) {
                viewModel.dismiss()
            }
        .toolbar(.visible, for: .navigationBar)
    }

    private var navigationTitleView: some View {
        Text(viewModel.title)
            .font(.poppins(.description))
            .foregroundStyle(Color.studioGrayPlaceholder)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let profileDecreaseTopPadding: CGFloat = -16
    static let profileDecreaseBottomPadding: CGFloat = -4
    static let closeButtonFrame: CGFloat = 12
}

// MARK: - Localization
private extension CustomFoodScreen {
    enum Localization {
        static let title: LocalizedStringKey = "CustomFoodScreen"
    }
}

struct CustomFoodScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomFoodScreen(
                viewModel: CustomFoodViewModel(
                    input: CustomFoodInput(context: .create),
                    output: { _ in }
                )
            )
        }
    }
}
