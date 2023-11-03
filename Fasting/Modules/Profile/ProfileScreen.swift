//  
//  ProfileScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: .zero) {

            // TODO: - Добавить плашку с планом сюда. Все паддинги расставлены

            ProfileButtonView(title: Localization.support,
                              image: .heart,
                              roundedCorners: .allCorners,
                              action: viewModel.contactSupport)
            .padding(.top, Layout.supportTopPadding)

            ProfileButtonView(title: Localization.termsOfUse,
                              image: nil,
                              roundedCorners: [.topLeft, .topRight],
                              action: viewModel.presentTermsOfUse)
            .padding(.top, Layout.termsOfUseTopPadding)

            ProfileButtonView(title: Localization.privacyPolicy,
                              image: nil,
                              roundedCorners: [.bottomLeft, .bottomRight],
                              action: viewModel.preesentPrivacyPolicy)
            .padding(.top, Layout.privacyPolicyTopPadding)
            Spacer()
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

// MARK: - Layout properties
private extension ProfileScreen {
    enum Layout {
        static let horizontalPadding: CGFloat = 32
        static let termsOfUseTopPadding: CGFloat = 32
        static let privacyPolicyTopPadding: CGFloat = 2
        static let supportTopPadding: CGFloat = 64
    }
}

// MARK: - Localization
private extension ProfileScreen {
    enum Localization {
        static let support: LocalizedStringKey = "ProfileScreen.support"
        static let termsOfUse: LocalizedStringKey = "ProfileScreen.termsOfUse"
        static let privacyPolicy: LocalizedStringKey = "ProfileScreen.privacyPolicy"
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            ProfileScreen(
                viewModel: ProfileViewModel(
                    input: ProfileInput(),
                    output: { _ in }
                )
            )
        }
    }
}
