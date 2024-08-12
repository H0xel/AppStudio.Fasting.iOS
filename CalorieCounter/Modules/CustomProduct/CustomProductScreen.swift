//  
//  CustomProductScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct CustomProductScreen: View {
    @StateObject var viewModel: CustomProductViewModel

    var body: some View {
        VStack(spacing: .zero) {
            CustomKeyboardScrollView(isKeyboardPresented: true, onScroll: {}) {
                Spacer(minLength: .spacing)
                VStack(spacing: .spacing) {
                    CustomProductTitleView(productName: viewModel.productName,
                                           brandName: viewModel.brandName)
                    CustomProductNutritionView(nutritionProfile: viewModel.nutritionProfile)
                    CustomProductServingView(serving: viewModel.serving, 
                                             servingValue: viewModel.servingValue,
                                             mlValue: viewModel.mlValue)

                    CustomProductIngredientsView(ingredients: viewModel.ingredients,
                                                 servingMultiplier: viewModel.servingMultiplier)
                        .padding(.horizontal, .ingredientsHorizontalPadding)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, .horizontalPadding)
            }
            .scrollIndicators(.hidden)
        }
        .animation(.linear(duration: 0.15), value: viewModel.isToolbarPresented)
        .closeButton(action: viewModel.dismiss)
        .navBarButton(
            placement: .topBarTrailing, 
            isVisible: viewModel.canShowSettings,
            content: Image.ellipsis
                .foregroundStyle(settingsButtonColor)
                .frame(width: .settingsButtonWidth, height: .settingsButtonWidth),
            action: viewModel.presentSettings
        )
    }

    private var settingsButtonColor: Color {
        viewModel.isToolbarPresented ? Color.studioGreyStrokeFill : .studioBlackLight
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 24
    static let titleSpacing: CGFloat = 24
    static let horizontalPadding: CGFloat = 16
    static let servingSpacing: CGFloat = 8
    static let circleWidth: CGFloat = 6
    static let ingredientsHorizontalPadding: CGFloat = 16
    static let settingsButtonWidth: CGFloat = 36
}


struct CustomProductScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            CustomProductScreen(
                viewModel: CustomProductViewModel(
                    input: CustomProductInput(mealItem: .mock), 
                    router: .init(navigator: .init()),
                    output: { _ in }
                )
            )
        }
    }
}
