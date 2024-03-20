//
//  UsageLimitPaywallScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI
import MunicornUtilities
import AppStudioServices

struct UsageLimitPaywallScreen: View {

    @StateObject var viewModel: PaywallViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Image(.freeUsagePaywall)
                .resizable()
                .frame(width: screenWidth)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    ZStack {
                        UsageLimitPaywallNavigationBar(close: viewModel.close,
                                                       restore: viewModel.restore)
                        Text(.unlockAllFeatures)
                            .font(.poppins(.accentS))
                            .foregroundStyle(.accent)
                            .multilineTextAlignment(.center)
                            .aligned(.bottom)
                            .padding(.bottom, .unlockBottomPadding)
                    }
                )
            Spacer()
            PaywallFeaturesView(features: features)
                .padding(.horizontal, .horizontalPadding)
            Spacer()
            PaywallOptionsView(popularSubscription: viewModel.popularProduct,
                               bestValueSubscription: viewModel.bestValueProduct,
                               weeklySubscription: viewModel.weeklySubscription,
                               selectedProduct: $viewModel.selectedProduct)
            .padding(.horizontal, .horizontalPadding)
            Spacer()
            AccentButton(title: .continueTitle,
                         action: viewModel.subscribe)
            .padding(.horizontal, .horizontalPadding)
            .padding(.bottom, .bottomPadding)
        }
        .onAppear {
            viewModel.appeared()
            viewModel.selectProduct(viewModel.bestValueProduct)
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
    }

    private var features: [String] {
        [.feture1, .feature2, .feature3]
    }
}

private extension CGFloat {
    static let unlockBottomPadding: CGFloat = 9
    static let featuresTopPadding: CGFloat = 39
    static let horizontalPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 8
    static let optionsBottomPadding: CGFloat = 40
}

private extension LocalizedStringKey {
    static let restore: LocalizedStringKey = "Paywall.restore"
    static let unlockAllFeatures: LocalizedStringKey = "UsageLimitPaywallScreen.unlockAllFeatures"
    static let continueTitle: LocalizedStringKey = "Paywall.Continue"
}

private extension String {
    static let feture1 = NSLocalizedString("UsageLimitPaywallScreen.feature1",
                                           comment: "")
    static let feature2 = NSLocalizedString("UsageLimitPaywallScreen.feature2",
                                            comment: "")
    static let feature3 = NSLocalizedString("UsageLimitPaywallScreen.feature3",
                                            comment: "")
}

#Preview {
    NavigationStack {
        UsageLimitPaywallScreen(viewModel: .init(input: .init(headerTitles: .defaultHeaderTitles,
                                                              paywallContext: .onboarding),
                                                 output: { _ in }))
    }
}
