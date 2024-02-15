//  
//  PersonalizedPaywallScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import SwiftUI
import AppStudioUI

struct PersonalizedPaywallScreen: View {
    @StateObject var viewModel: PersonalizedPaywallViewModel

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                PersonalizedTitleView(viewData: viewModel.headerViewData)

                if let promoProduct = viewModel.promoProduct {
                    PersonalizedPromotionalOfferView(viewData: .init(
                        duration: promoProduct.duration,
                        price: promoProduct.price)
                    )
                    .padding(.bottom, Layout.promotOfferBottomPadding)
                }

                PersonalizedChart(viewData: viewModel.input.chart)
                    .padding(.bottom, Layout.chartBottomPadding)

                PersonalizedBulletPointsView(viewData: viewModel.input.bulletPoints)
                    .padding(.bottom, Layout.bulletBottomPadding)

                PersonalizedTabView(sex: viewModel.input.sex, weightUnit: viewModel.input.weightUnit)
                    .padding(.bottom, Layout.tabBottomPadding)

                PersonalizedDescriptionView(viewData: viewModel.input.descriptionPoints)

                Color.clear
                    .frame(height: Layout.bottomSpacing)
            }
            VStack(spacing: .zero) {
                AccentButton(title: .localizedString(Localization.continueTitle)) {
                    viewModel.subscribe()
                }
                .padding(.horizontal, Layout.bottomButtonHorizontalPadding)
            }
            .padding(.top, Layout.topButtonPadding)
            .padding(.bottom, Layout.buttonBottomPadding)
            .background()
            .aligned(.bottom)
        }
        .onAppear(perform: viewModel.appeared)
        .navBarButton(placement: .navigationBarTrailing,
                      isVisible: true,
                      content: Image.close
            .foregroundStyle(.fastingGreyStrokeFill)
            .opacity(viewModel.canDisplayCloseButton ? 1 : 0),
                      action: viewModel.close)
        .navBarButton(content: restoreButton,
                      action: viewModel.restore)
    }

    private var restoreButton: some View {
        Text(Localization.restore)
            .foregroundColor(.fastingGrayPlaceholder)
            .font(.poppins(.buttonText))
            .opacity(viewModel.canDisplayCloseButton ? 1 : 0)
    }
}

// MARK: - Layout properties
private extension PersonalizedPaywallScreen {
    enum Layout {
        static let bottomButtonHorizontalPadding: CGFloat = 32
        static let bottomSpacing: CGFloat = 60
        static let tabBottomPadding: CGFloat = 10
        static let chartBottomPadding: CGFloat = 10
        static let bulletBottomPadding: CGFloat = 20
        static let buttonBottomPadding: CGFloat = UIScreen.isSmallDevice ? 10 : 0
        static let topButtonPadding: CGFloat = 10
        static var promotOfferBottomPadding: CGFloat = 8
    }
}

// MARK: - Localization
private extension PersonalizedPaywallScreen {
    enum Localization {
        static let restore: LocalizedStringKey = "Paywall.restore"
        static let continueTitle: LocalizedStringKey = "Paywall.Continue"
    }
}

#Preview {
    NavigationStack {
        PersonalizedPaywallScreen(
            viewModel: PersonalizedPaywallViewModel(
                input: .mock,
                output: { _ in }
            )
        )
    }
}
