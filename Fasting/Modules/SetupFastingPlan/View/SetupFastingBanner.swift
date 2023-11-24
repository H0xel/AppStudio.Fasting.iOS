//
//  SetupFastingBanner.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI

struct SetupFastingBanner: View {
    let plan: FastingPlan
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Text(plan.intervalPlan)
                        .foregroundStyle(.white)
                        .font(.poppins(.accentS))
                    Text(plan.intervalDescription)
                        .foregroundStyle(.white)
                        .font(.poppins(.headerS))
                }
                Spacer()
            }
            .padding(.vertical, Layout.verticalPadding)
            SetupFastingButton(
                title: Localization.buttonTitle,
                color: plan.backgroundColor
            ) {
                action()
            }

            .frame(width: 101)
            .padding(.bottom, Layout.buttonBottomPadding)
        }
        .fastingPlanBackground(plan)
        .continiousCornerRadius(Layout.cornerRadius)
    }
}

private extension SetupFastingBanner {
    enum Layout {
        static let verticalPadding: CGFloat = 32
        static let buttonBottomPadding: CGFloat = 24
        static let buttonWidth: CGFloat = 100
        static let cornerRadius: CGFloat = 40
    }
}

// MARK: - Localization
private extension SetupFastingBanner {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "SetupFasting.buttonBannerTitle"
    }
}

#Preview {
    SetupFastingBanner(plan: .beginner, action: {})
}
