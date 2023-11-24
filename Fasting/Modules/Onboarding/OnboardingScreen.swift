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
        ZStack {
            VStack(spacing: 0) {
                Image(.onboardingMock)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }

            VStack(spacing: .zero) {
                Spacer()
                LinearGradient(colors: [.white, .background.opacity(0)],
                               startPoint: .bottom,
                               endPoint: .top)
                .frame(height: Layout.gradientHeight)

                VStack(spacing: .zero) {
                    Text(Localization.description)
                        .multilineTextAlignment(.center)
                        .font(.poppins(.headerL))
                        .padding(.bottom, Layout.textVerticalPadding)
                        .background()
                    AccentButton(title: Localization.buttonTitle) {
                        viewModel.getStartedTapped()
                    }
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.buttonBottomPadding)
                .background()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

// MARK: - Layout properties
private extension OnboardingScreen {
    enum Layout {
        static let textVerticalPadding: CGFloat = 56
        static let buttonBottomPadding: CGFloat = 58
        static let horizontalPadding: CGFloat = 32
        static let gradientHeight: CGFloat = 100
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
