//
//  OnboardingStartView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI
import AppStudioStyles

struct OnboardingStartView: View {

    let onTap: (Action) -> Void

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
                        onTap(.continueTap)
                    }

                    PrivacyAndTermsOnboardingView(
                        privacyUrl: GlobalConstants.privacyPolicy,
                        termsUrl: GlobalConstants.termsOfUse
                    )
                    .padding(.top, Layout.topPadding)

                }
                .padding(.horizontal, Layout.horizontalPadding)
                .background()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

extension OnboardingStartView {
    enum Action {
        case termsTapped
        case privacyTapped
        case continueTap
    }
}

private extension OnboardingStartView {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "Onboarding.buttonTitle"
        static let description: LocalizedStringKey = "Onboarding.description"
    }

    enum Layout {
        static let textVerticalPadding: CGFloat = 24
        static let horizontalPadding: CGFloat = 32
        static let gradientHeight: CGFloat = 100
        static let topPadding: CGFloat = 16
    }
}

#Preview {
    OnboardingStartView { _ in }
}
