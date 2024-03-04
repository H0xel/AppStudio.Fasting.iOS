//
//  OnboardingEstimatedExpenditureView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 08.01.2024.
//

import SwiftUI

struct OnboardingEstimatedExpenditureView: View {
    let kcalAmount: String

    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                VStack(spacing: .zero) {
                    ZStack {
                        Rectangle()
                            .frame(width: .iconFrame, height: .iconFrame)
                            .foregroundStyle(Color.studioSky)
                            .continiousCornerRadius(.iconCornerRadius)
                            .padding(.vertical, .iconVerticalPadding)

                        Image.figureRun
                            .foregroundStyle(.white)
                            .font(.system(size: .iconSize))
                    }

                    VStack(spacing: .zero) {
                        Text(Localization.title(kcalAmount))
                            .font(.poppins(.accentS))
                            .padding(.bottom, .titleBottomPadding)

                        Text(Localization.subTitle)
                            .font(.poppins(.headerM))
                    }
                    .aligned(.centerHorizontaly)
                }
                .padding(.horizontal, .bannerHorizontalPadding)
                .padding(.bottom, .bannerBottomPadding)
                .background(Color.studioGrayFillCard)
                .continiousCornerRadius(.bannerCornerRadius)

                Text(Localization.description)
                    .font(.poppins(.body))
                    .padding(.horizontal, .descriptionHorizontalPadding)
                    .padding(.top, .descriptionTopPading)
            }
            .multilineTextAlignment(.center)
            .padding(.top, .topPadding)
            Spacer(minLength: .bottomPadding)
        }
        .scrollIndicators(.hidden)
    }
}

private extension CGFloat {
    static let iconFrame: CGFloat = 64
    static let iconCornerRadius: CGFloat = 16
    static let iconVerticalPadding: CGFloat = 88
    static let iconSize: CGFloat = 30

    static let titleBottomPadding: CGFloat = 16
    static let bannerHorizontalPadding: CGFloat = 40
    static let bannerBottomPadding: CGFloat = 40
    static let bannerCornerRadius: CGFloat = 20

    static let descriptionHorizontalPadding: CGFloat = 20
    static let descriptionTopPading: CGFloat = 40

    static let topPadding: CGFloat = 24
    static var bottomPadding: CGFloat = 120
}

private enum  Localization {
    static func title(_ kcal: String) -> String {
        String(format: NSLocalizedString("OnboardingEstimatedExpenditureView.title", comment: ""), kcal)
    }
    static let subTitle: LocalizedStringKey = "OnboardingEstimatedExpenditureView.subtitle"
    static let description: LocalizedStringKey = "OnboardingEstimatedExpenditureView.description"
}

#Preview {
    OnboardingEstimatedExpenditureView(kcalAmount: "1234,5")
        .padding(.horizontal, 32)
}
