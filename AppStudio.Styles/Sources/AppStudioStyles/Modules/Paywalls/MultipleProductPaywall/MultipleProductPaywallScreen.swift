//
//  UsageLimitPaywallScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI
import AppStudioModels
import MunicornUtilities

public struct MultipleProductPaywallScreen: View {
    @Binding var selectedProduct: SubscriptionProduct?
    let popularProduct: SubscriptionProduct
    let bestValueProduct: SubscriptionProduct
    let weeklyProduct: SubscriptionProduct
    let type: SourceType
    var action: (Event) -> Void

    public init(selectedProduct: Binding<SubscriptionProduct?>,
                popularProduct: SubscriptionProduct,
                bestValueProduct: SubscriptionProduct,
                weeklyProduct: SubscriptionProduct,
                type: SourceType,
                action: @escaping (Event) -> Void
    ) {
        _selectedProduct = selectedProduct
        self.popularProduct = popularProduct
        self.bestValueProduct = bestValueProduct
        self.weeklyProduct = weeklyProduct
        self.type = type
        self.action = action
    }

    public var body: some View {
        VStack(spacing: .zero) {
            type.image
                .resizable()
                .frame(width: screenWidth)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    ZStack {
                        UsageLimitPaywallNavigationBar(action: action)
                        Text("Paywall.unlockAllFeatures".localized(bundle: .module))
                            .font(.poppinsBold(.accentS))
                            .foregroundStyle(Color.studioBlackLight)
                            .multilineTextAlignment(.center)
                            .aligned(.bottom)
                            .padding(.bottom, .unlockBottomPadding)
                    }
                )
            Spacer()
            PaywallFeaturesView(features: type.featuresTitles)
                .padding(.horizontal, .horizontalPadding)
            Spacer()
            PaywallOptionsView(popularSubscription: popularProduct,
                               bestValueSubscription: bestValueProduct,
                               weeklySubscription: weeklyProduct,
                               selectedProduct: $selectedProduct)
            .padding(.horizontal, .horizontalPadding)
            Spacer()
            AccentButton(title: .string("Paywall.continue".localized(bundle: .module))) {
                action(.subscribe)
            }
            .padding(.horizontal, .horizontalPadding)
            .padding(.bottom, .bottomPadding)

            HStack(spacing: .zero) {
                Spacer()
                Button(action: {
                    action(.presentTermsOfUse)
                }, label: {
                    Text("ProfileScreen.termsOfUse".localized(bundle: .module))
                        .font(.poppins(.description))
                })
                .foregroundStyle(Color.studioBlackLight)
                Spacer()
                Button(action: {
                    action(.presentPrivacyPolicy)
                }, label: {
                    Text("ProfileScreen.privacyPolicy".localized(bundle: .module))
                        .font(.poppins(.description))
                })
                .foregroundStyle(Color.studioBlackLight)
                Spacer()
            }
            .padding(.bottom, .bottomPadding)
        }
        .onAppear {
            action(.appeared)
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
    }
}

public extension MultipleProductPaywallScreen {
    struct ViewData {
        @Binding var selectedProduct: SubscriptionProduct
        let popularProduct: SubscriptionProduct
        let bestValueProduct: SubscriptionProduct
        let weeklyProduct: SubscriptionProduct
        let type: SourceType
        var action: (Event) -> Void

        public init(selectedProduct: Binding<SubscriptionProduct>,
                    popularProduct: SubscriptionProduct,
                    bestValueProduct: SubscriptionProduct,
                    weeklyProduct: SubscriptionProduct,
                    type: SourceType,
                    action: @escaping (Event) -> Void
        ) {
            _selectedProduct = selectedProduct
            self.popularProduct = popularProduct
            self.bestValueProduct = bestValueProduct
            self.weeklyProduct = weeklyProduct
            self.type = type
            self.action = action
        }
    }

    enum Event {
        case close
        case restore
        case subscribe
        case appeared
        case presentTermsOfUse
        case presentPrivacyPolicy
    }

    enum SourceType {
        case fasting
        case calorieCounter

        var image: Image {
            switch self {
            case .fasting:
                Image(.fastingPaywallHeader)
            case .calorieCounter:
                Image(.calorieCounterPaywallHeader)
            }
        }

        var featuresTitles: [String] {
            switch self {
            case .fasting:
                [
                    "Paywall.fasting.feature1".localized(bundle: .module),
                    "Paywall.fasting.feature2".localized(bundle: .module),
                    "Paywall.fasting.feature3".localized(bundle: .module)
                ]
            case .calorieCounter:
                [
                    "Paywall.calorieCounter.feature1".localized(bundle: .module),
                    "Paywall.calorieCounter.feature2".localized(bundle: .module),
                    "Paywall.calorieCounter.feature3".localized(bundle: .module)
                ]
            }
        }
    }
}

private extension CGFloat {
    static let unlockBottomPadding: CGFloat = 9
    static let featuresTopPadding: CGFloat = 39
    static let horizontalPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 8
    static let optionsBottomPadding: CGFloat = 40
}

private extension String {
    static let feature1 = NSLocalizedString("UsageLimitPaywallScreen.feature1",
                                           comment: "")
    static let feature2 = NSLocalizedString("UsageLimitPaywallScreen.feature2",
                                            comment: "")
    static let feature3 = NSLocalizedString("UsageLimitPaywallScreen.feature3",
                                            comment: "")
}

#Preview {
    NavigationStack {
        MultipleProductPaywallScreen(
            selectedProduct: .constant(.mock),
            popularProduct: .mock,
            bestValueProduct: .mock,
            weeklyProduct: .mock,
            type: .fasting,
            action: { _ in })
    }
}
