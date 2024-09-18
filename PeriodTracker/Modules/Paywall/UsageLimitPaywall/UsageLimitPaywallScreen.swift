//
//  UsageLimitPaywallScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI
import MunicornUtilities
import AppStudioServices
import AppStudioStyles

struct UsageLimitPaywallScreen: View {

    @StateObject var viewModel: UsageLimitPaywallViewModel

    var body: some View {
        MultipleProductPaywallScreen(
            selectedProduct: $viewModel.selectedProduct,
            popularProduct: viewModel.popularProduct,
            bestValueProduct: viewModel.bestValueProduct,
            weeklyProduct: viewModel.weeklySubscription,
            type: .calorieCounter,
            action: viewModel.handle)
    }
}

#Preview {
    NavigationStack {
        UsageLimitPaywallScreen(viewModel: .init(input: .init(headerTitles: .defaultHeaderTitles,
                                                              paywallContext: .onboarding),
                                                 output: { _ in }))
    }
}
