//  
//  NotificationOnboardingScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct NotificationOnboardingScreen: View {
    @StateObject var viewModel: NotificationOnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {

            Text(Localization.title)
                .font(.poppins(.headerL))
                .padding(.horizontal, Layout.titleHorizontalPadding)
                .padding(.bottom, Layout.titleBottomPadding)
                .padding(.top, Layout.titleTopPadding)
                .multilineTextAlignment(.center)
            Image(.notification)
                .resizable()
            AccentButton(title: Localization.buttonTitle) {
                viewModel.notificationButtonTapped()
            }
            .padding(.horizontal, Layout.horizontalPadding)
        }
    }
}

// MARK: - Layout properties
private extension NotificationOnboardingScreen {
    enum Layout {
        static let horizontalPadding: CGFloat = 32
        static let titleHorizontalPadding: CGFloat = 53
        static let titleBottomPadding: CGFloat = 40
        static let titleTopPadding: CGFloat = 72
    }
}

// MARK: - Localization
private extension NotificationOnboardingScreen {
    enum Localization {
        static let title: LocalizedStringKey = "NotificationOnboarding.title"
        static let buttonTitle: LocalizedStringKey = "NotificationOnboarding.button"
    }
}

struct NotificationOnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationOnboardingScreen(
            viewModel: NotificationOnboardingViewModel(
                input: NotificationOnboardingInput(),
                output: { _ in }
            )
        )
    }
}