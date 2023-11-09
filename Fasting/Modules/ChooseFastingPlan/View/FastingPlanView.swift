//
//  FastingPlanView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioFoundation

struct FastingPlanView: View {
    let plan: FastingPlan
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(plan.title)
                .padding(.top, Layout.titleTopPadding)
                .padding(.bottom, Layout.titleBottomPadding)
                .foregroundStyle(.white)
                .font(.poppins(.headerS))

            Text(plan.description)
                .foregroundStyle(.white)
                .font(.poppins(.description))
                .padding(.horizontal, Layout.descriptionHorizontalPadding)
                .padding(.vertical, Layout.descriptionVerticalPadding)
                .background(plan.descriptionBackgroundColor)
                .continiousCornerRadius(Layout.descriptionCornerRadius)

            Spacer()
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: Layout.planIntervalSpacing) {
                    Text(plan.intervalPlan)
                        .foregroundStyle(.white)
                        .font(.poppins(.accentL))
                    Text(plan.intervalDescription)
                        .foregroundStyle(.white)
                        .font(.poppins(.headerS))
                }
                Spacer()
            }

            Spacer()
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
        static let titleTopPadding: CGFloat = 32
        static let titleBottomPadding: CGFloat = 16
        static let descriptionHorizontalPadding: CGFloat = 12
        static let descriptionVerticalPadding: CGFloat = 10
        static let descriptionCornerRadius: CGFloat = 56
        static let planIntervalSpacing: CGFloat = 28
        static let planIntervalHorizontalPadding: CGFloat = 60
        static let buttonHorizontalPadding: CGFloat = 24
        static let buttonBottomPadding: CGFloat = 24
        static let horizontalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 40
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
