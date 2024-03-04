//
//  OnboardingFlowIndicatorView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.12.2023.
//

import SwiftUI

private let screenWidth: CGFloat = UIScreen.main.bounds.width

struct OnboardingFlowIndicatorView: View {

    let currentStep: OnboardingFlowStep

    var body: some View {
        ZStack {
            HStack(spacing: .zero) {
                ForEach(OnboardingFlowStep.flowSteps, id: \.rawValue) { step in
                    Rectangle()
                        .fill(Color.studioGreyStrokeFill)
                        .frame(height: Layout.stepIndicatorHeight)
                        .opacity(currentStep.rawValue < step.rawValue ? 1 : 0)
                    Color.white
                        .frame(width: Layout.indicatorsSpacing,
                               height: Layout.stepIndicatorHeight)
                        .opacity(currentStep.rawValue < step.rawValue ? 1 : 0)
                }
            }
            .background(
                gradient
                    .frame(height: Layout.stepIndicatorHeight)
            )
        }
        .frame(width: navBarIndicatorWidth)
    }

    private var gradient: some View {
        LinearGradient(
            colors: [
                .studioBlue,
                .studioPurple,
                .studioRed,
                .studioOrange,
                .studioGreen,
                .studioSky
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var navBarIndicatorWidth: CGFloat {
        screenWidth - Layout.navBarHorizontalPadding * 2
    }
}

private extension OnboardingFlowIndicatorView {
    enum Layout {
        static let navBarHorizontalPadding: CGFloat = 24
        static let stepIndicatorHeight: CGFloat = 4
        static let indicatorsSpacing: CGFloat = 2
    }
}

#Preview {
    OnboardingFlowIndicatorView(currentStep: .birthday)
}
