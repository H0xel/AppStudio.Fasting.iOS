//
//  OnboardingStartView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingStartView: View {

    let onTap: () -> Void

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
                    AccentButton(title: Localization.buttonTitle, action: onTap)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.buttonBottomPadding)
                .background()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

private extension OnboardingStartView {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "Onboarding.buttonTitle"
        static let description: LocalizedStringKey = "Onboarding.description"
    }

    enum Layout {
        static let textVerticalPadding: CGFloat = 56
        static let buttonBottomPadding: CGFloat = 58
        static let horizontalPadding: CGFloat = 32
        static let gradientHeight: CGFloat = 100
    }
}

#Preview {
    OnboardingStartView {}
}
