//
//  FastingPlanView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioFoundation
import AppStudioUI

struct FastingPlanView: View {
    let plan: FastingPlan
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(plan.title)
                .padding(.top, Layout.titleTopPadding)
                .padding(.bottom, Layout.titleBottomPadding)
                .foregroundStyle(.white)
                .font(.adaptivePoppins(font: .headerS, smallDeviceFont: .buttonText))

            Text(plan.fastingDescription)
                .foregroundStyle(.white)
                .font(.poppins(.description))
                .padding(.horizontal, Layout.descriptionHorizontalPadding)
                .padding(.vertical, Layout.descriptionVerticalPadding)
                .background(plan.descriptionBackgroundColor)
                .continiousCornerRadius(Layout.descriptionCornerRadius)

            VStack(spacing: 0) {
                Spacer()
                Text(plan.intervalPlan)
                    .foregroundStyle(.white)
                    .font(.adaptivePoppins(font: .accentL, smallDeviceFont: .accentS))
                    .frame(height: Layout.intervalPlanHeight)
                    .padding(.bottom, Layout.intervalPlanBottomPadding)
                Text(plan.intervalDescription)
                    .foregroundStyle(.white)
                    .font(.adaptivePoppins(font: .headerS, smallDeviceFont: .description))
                Spacer()
            }

            AccentButton(title: Localization.buttonTitle) {
                action()
            }
            .padding(.horizontal, Layout.buttonHorizontalPadding)
            .padding(.bottom, Layout.buttonBottomPadding)
        }
        .clipped()
        .fastingPlanBackground(plan)
        .continiousCornerRadius(Layout.cornerRadius)
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Layout properties
private extension FastingPlanView {
    enum Layout {
        static let titleTopPadding: CGFloat = 24
        static let titleBottomPadding: CGFloat = 8
        static let descriptionHorizontalPadding: CGFloat = 12
        static let descriptionVerticalPadding: CGFloat = 8
        static let descriptionCornerRadius: CGFloat = 56
        static let planIntervalSpacing: CGFloat = 28
        static let planIntervalHorizontalPadding: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 24
        static let buttonBottomPadding: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 40
        static let intervalPlanHeight: CGFloat = UIScreen.isSmallDevice ? 53 : 100
        static let intervalPlanBottomPadding: CGFloat = 4
    }
}

// MARK: - Localization
private extension FastingPlanView {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "ChooseFastingPlan.buttonTitle"
    }
}

#Preview {
    FastingPlanView(plan: .beginner) {}
}
