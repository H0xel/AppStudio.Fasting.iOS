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
        ZStack {
            VStack(spacing: .zero) {
                if viewModel.context == .settingsScreen {
                    HStack {
                        Spacer()
                        Button(action: viewModel.restore,
                               label: {
                            restoreButton
                                .padding(.trailing, Layout.tabBarRestoreButtonTrailingPadding)
                                .padding(.vertical, Layout.tabBarRestoreButtonVerticalPadding)
                        })
                    }
                }

                PaywallTitleView(titles: viewModel.headerTitles)
                    .padding(.horizontal, Layout.horizontalPadding)
                    .padding(.top, Layout.verticalPadding)

                ShadingImageView(image: .paywall)
                Spacer()
            }

            VStack(spacing: .zero) {
                Spacer()
                LinearGradient(
                    colors: [.white, .background.opacity(0)],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: Layout.shadingHeight)
                PaywallBottomInfoView(bottomInfo: viewModel.bottomInfo, onSaveTap: viewModel.subscribe)
                    .background()
                    .padding(.bottom, Layout.verticalPadding)
                    .padding(.horizontal, Layout.horizontalPadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(isVisible: viewModel.context != .settingsScreen && viewModel.canDisplayCloseButton,
                      content: Image.close.foregroundStyle(.fastingGreyStrokeFill),
                      action: viewModel.close)
        .navBarButton(placement: .navigationBarTrailing,
                      isVisible: viewModel.context != .settingsScreen,
                      content: restoreButton,
                      action: viewModel.restore)
        .onAppear {
            viewModel.appeared()
        }
    }

    private var restoreButton: some View {
        Text(Localization.restore)
            .foregroundColor(.fastingGrayPlaceholder)
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
        static let tabBarRestoreButtonVerticalPadding: CGFloat = 16
    }
}

struct PaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaywallScreen(viewModel: .init(input: .mock, output: { _ in }))
        }
    }
}
