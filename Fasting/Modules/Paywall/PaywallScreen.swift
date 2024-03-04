//
//  PaywallScreen.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 03.08.2023.
//

import SwiftUI
import AppStudioUI

struct PaywallScreen: View {
    @StateObject var viewModel: PaywallViewModel

    var body: some View {
        VStack(spacing: .zero) {
            if isSettings {
                Button(action: viewModel.restore) {
                    restoreButton
                        .padding(.trailing, Layout.tabBarRestoreButtonTrailingPadding)
                        .padding(.top, Layout.tabBarRestoreButtonBottomPadding)
                }
                .aligned(.right)
            }

            PaywallTitleView(titles: viewModel.headerTitles)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, Layout.verticalPadding)

            ShadingImageView(image: isSettings ? .init(.paywallImageTabBar) : .paywall)

            Spacer()

            PaywallBottomInfoView(bottomInfo: viewModel.bottomInfo, onSaveTap: viewModel.subscribe)
                .background()
                .padding(.bottom, Layout.verticalPadding)
                .padding(.horizontal, Layout.horizontalPadding)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(isVisible: viewModel.context != .paywallTab && viewModel.canDisplayCloseButton,
                      content: Image.close.foregroundStyle(Color.studioGreyStrokeFill),
                      action: viewModel.close)
        .navBarButton(placement: .navigationBarTrailing,
                      isVisible: !isSettings,
                      content: restoreButton,
                      action: viewModel.restore)
        .onAppear(perform: viewModel.appeared)
    }

    private var restoreButton: some View {
        Text(Localization.restore)
            .foregroundColor(.studioGrayPlaceholder)
            .font(.poppins(.buttonText))
    }

    private var isSettings: Bool {
        viewModel.context == .paywallTab
    }
}

private extension PaywallScreen {
    enum Localization {
        static let restore: LocalizedStringKey = "Paywall.restore"
        static let noPaymentsNow: LocalizedStringKey = "Paywall.noPaymentNow"
        static let title = NSLocalizedString("Paywall.reachYourWeightGoals", comment: "")
    }

    enum Layout {
        static let bottomInfoTopPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 16
        static let titleSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 32
        static let shadingHeight: CGFloat = 70
        static let tabBarRestoreButtonTrailingPadding: CGFloat = 16
        static let tabBarRestoreButtonBottomPadding: CGFloat = 10
        static let imageBottomPadding: CGFloat = 24
    }
}

struct PaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaywallScreen(viewModel: .init(input: .mock, output: { _ in }))
        }
    }
}
