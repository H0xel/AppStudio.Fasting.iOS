//
//  OnboardingStartView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

public struct OnboardingStartView: View {

    let viewData: ViewData
    let onTap: (Action) -> Void

    public init(viewData: ViewData, onTap: @escaping (Action) -> Void) {
        self.viewData = viewData
        self.onTap = onTap
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                viewData.image
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
                    Text(viewData.description)
                        .multilineTextAlignment(.center)
                        .font(.poppins(.headerL))
                        .padding(.bottom, Layout.textVerticalPadding)
                        .background()
                    AccentButton(
                        title: .string(viewData.buttonTitle),
                        backgroundColor: Color.studioBlueLight
                    ) {
                        onTap(.getStartedTapped)
                    }

                    if let w2wViewData = viewData.w2wViewData {
                        HStack(spacing: Layout.bottomW2WSpacing) {
                            Text(w2wViewData.w2wTitle)
                                .font(.poppins(.description))
                            Button(action: {
                                onTap(.w2wSignIn)
                            }, label: {
                                HStack(spacing: Layout.buttonSpacing) {
                                    Text(w2wViewData.w2wButtonTile)
                                    Image.arrowRight
                                }
                                .font(.poppinsMedium(.description))
                            })
                        }
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.top, Layout.topW2WPadding)
                    }

                    PrivacyAndTermsOnboardingView(
                        privacyUrl: viewData.privacyURL,
                        termsUrl: viewData.termsURL
                    )
                    .padding(.top, Layout.topTermsPadding)
                }
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.buttonBottomPadding)
                .background()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .if(viewData.withInterCome) { view in
            view
                .navBarButton(placement: .topBarTrailing,
                              content: W2WNeedHelpView(),
                              action: { onTap(.intercome) })
        }
    }
}

public extension OnboardingStartView {
    struct ViewData {
        let image: Image
        let description: String
        let buttonTitle: String
        let privacyURL: String
        let termsURL: String

        let w2wViewData: W2WViewData?
        let withInterCome: Bool

        public init(image: Image, 
                    description: String,
                    buttonTitle: String,
                    privacyURL: String,
                    termsURL: String,
                    w2wViewData: W2WViewData?,
                    withInterCome: Bool) {
            self.image = image
            self.description = description
            self.buttonTitle = buttonTitle
            self.privacyURL = privacyURL
            self.termsURL = termsURL
            self.w2wViewData = w2wViewData
            self.withInterCome = withInterCome
        }
    }

    struct W2WViewData {
        let w2wTitle: String
        let w2wButtonTile: String
    }
}

public extension OnboardingStartView {
    enum Action {
        case getStartedTapped
        case w2wSignIn
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
