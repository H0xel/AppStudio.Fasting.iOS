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
            PaywallTitleView(titles: viewModel.headerTitles)
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.top, Layout.verticalPadding)

            ShadingImageView(image: .paywall)

            Spacer()

            PaywallBottomInfoView(bottomInfo: viewModel.bottomInfo, action: viewModel.handle)
                .background()
                .padding(.bottom, Layout.verticalPadding)
                .padding(.horizontal, Layout.horizontalPadding)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(
            content: Image.close
                .foregroundStyle(Color.studioGreyStrokeFill)
                .opacity(viewModel.canDisplayCloseButton ? 1 : 0),
            action: viewModel.close
        )
        .navBarButton(placement: .navigationBarTrailing,
                      content: restoreButton,
                      action: viewModel.restore)
        .onAppear(perform: viewModel.appeared)
    }

    private var restoreButton: some View {
        Text(Localization.restore)
            .foregroundColor(.studioGrayPlaceholder)
            .font(.poppins(.buttonText))
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
