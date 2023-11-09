//  
//  OnboardingScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation

struct OnboardingScreen: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Image(.onboardingMock)
                .resizable()

            VStack(spacing: 0) {
                Text(Localization.description)
                    .multilineTextAlignment(.center)
                    .font(.poppins(.headerL))
                    .padding(.vertical, Layout.textVerticalPadding)
                AccentButton(title: Localization.buttonTitle) {
                    viewModel.getStartedTapped()
                }
                .padding(.bottom, Layout.buttonBottomPadding)
            }
            .padding(.horizontal, Layout.horizontalPadding)
        }
        .ignoresSafeArea()
    }
}

// MARK: - Layout properties
private extension OnboardingScreen {
    enum Layout {
        static let textVerticalPadding: CGFloat = 56
        static let buttonBottomPadding: CGFloat = 73
        static let horizontalPadding: CGFloat = 32
    }
}

// MARK: - Localization
private extension OnboardingScreen {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "Onboarding.buttonTitle"
        static let description: LocalizedStringKey = "Onboarding.description"
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(
            viewModel: OnboardingViewModel(
                input: OnboardingInput(),
                output: { _ in }
            )
        )
    }
}
