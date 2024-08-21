//
//  OnboardingStartView.swift
//  Fasting
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
                    AccentButton(title: .localizedString(Localization.buttonTitle)) {
                        onTap(.getStartedTapped)
                    }

                    HStack(spacing: Layout.bottomW2WSpacing) {
                        Text("W2W.onboarding.title")
                            .font(.poppins(.description))
                        Button(action: {
                            onTap(.w2wSignIn)
                        }, label: {
                            HStack(spacing: Layout.buttonSpacing) {
                                Text("W2W.onboarding.signIn")
                                Image.arrowRight
                            }
                            .font(.poppinsMedium(.description))
                        })
                    }
                    .foregroundStyle(Color.studioBlackLight)
                    .padding(.top, Layout.topW2WPadding)

                    PrivacyAndTermsOnboardingView(
                        privacyUrl: GlobalConstants.privacyPolicy,
                        termsUrl: GlobalConstants.termsOfUse
                    )
                    .padding(.top, Layout.topTermsPadding)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.buttonBottomPadding)
                .background()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .navBarButton(placement: .topBarTrailing,
                      content: W2WNeedHelpView(),
                      action: { onTap(.intercome) })
    }
}

extension OnboardingStartView {
    enum Action {
        case getStartedTapped
        case w2wSignIn
        case termsTapped
        case privacyTapped
        case intercome
    }
}

private extension OnboardingStartView {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "Onboarding.buttonTitle"
        static let description: LocalizedStringKey = "Onboarding.description"
    }

    enum Layout {
        static let textVerticalPadding: CGFloat = 24
        static let buttonBottomPadding: CGFloat = 38
        static let horizontalPadding: CGFloat = 32
        static let gradientHeight: CGFloat = 100
        static let buttonSpacing: CGFloat = 4
        static let bottomW2WSpacing: CGFloat = 16
        static let topW2WPadding: CGFloat = 20
        static let topTermsPadding: CGFloat = 8
    }
}

#Preview {
    OnboardingStartView { _ in }
}
