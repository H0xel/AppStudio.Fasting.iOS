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

            Spacer()
            ShadingImageView(image: .paywall)
            Spacer(minLength: Layout.bottomInfoTopPadding)

            PaywallBottomInfoView(onSaveTap: viewModel.subscribe)
                .padding(.bottom, Layout.bottomPadding)
                .padding(.horizontal, Layout.horizontalPadding)
        }
        .background(
            LinearGradient(colors: [.white, .white, .background],
                           startPoint: .bottom,
                           endPoint: .top)
        )
        .navigationBarTitleDisplayMode(.inline)
        .closeButton(color: .tertiaryLabel, action: viewModel.close)
        .navBarButton(placement: .navigationBarTrailing,
                      content: restoreButton,
                      action: viewModel.restore)
    }

    private var restoreButton: some View {
        Text(Localization.restore)
            .foregroundColor(.tertiaryLabel)
    }
}

private extension PaywallScreen {
    enum Localization {
        static let title: LocalizedStringKey = "Paywall.title"
        static let restore: LocalizedStringKey = "Paywall.restore"
        static let noPaymentsNow: LocalizedStringKey = "Paywall.noPaymentNow"
    }

    enum Layout {
        static let bottomInfoTopPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 16
        static let titleSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 36
    }
}

struct PaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaywallScreen(viewModel: .init(input: .mock, output: { _ in }))
        }
    }
}
