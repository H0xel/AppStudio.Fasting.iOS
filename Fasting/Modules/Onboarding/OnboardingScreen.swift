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
                    .overlay {
                        LinearGradient(colors: [.white, .background.opacity(0)],
                                       startPoint: .bottom,
                                       endPoint: .top)
                        .frame(height: Layout.gradientHeight)
                        .aligned(.bottom)
                    }
                Spacer()
            }

            VStack(spacing: 0) {
                Spacer()
                Text(Localization.description)
                    .multilineTextAlignment(.center)
                    .font(.poppins(.headerL))
                    .padding(.vertical, Layout.textVerticalPadding)
                AccentButton(title: Localization.buttonTitle) {
                    viewModel.getStartedTapped()
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.bottom, Layout.buttonBottomPadding)
        }
        .frame(width: UIScreen.main.bounds.width)
        .ignoresSafeArea(edges: .top)
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
