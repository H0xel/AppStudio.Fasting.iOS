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
        VStack(spacing: Layout.buttonSpacing) {
            VStack(spacing: Layout.spacing) {
                Text(plan.intervalPlan)
                    .foregroundStyle(.white)
                    .font(.poppins(.headerL))
                    .frame(height: Layout.planHeight)
                Text(plan.intervalDescription)
                    .foregroundStyle(.white)
                    .font(.poppins(.body))
                    .frame(height: Layout.descriptionHeight)
            }
            .aligned(.centerHorizontaly)

            SetupFastingButton(
                title: Localization.buttonTitle,
                color: plan.backgroundColor
            ) {
                action()
            }
        }
        .padding(.vertical, Layout.verticalPadding)
        .fastingPlanBackground(plan)
        .continiousCornerRadius(Layout.cornerRadius)
    }
}

private extension SetupFastingBanner {
    enum Layout {
        static let verticalPadding: CGFloat = 24
        static let spacing: CGFloat = 4
        static let cornerRadius: CGFloat = 20
        static let planHeight: CGFloat = 42
        static let descriptionHeight: CGFloat = 18
        static let buttonSpacing: CGFloat = 24
    }
}

// MARK: - Localization
private extension SetupFastingBanner {
    enum Localization {
        static let buttonTitle: LocalizedStringKey = "SetupFasting.buttonBannerTitle"
    }
}

#Preview {
    SetupFastingBanner(plan: .regular, action: {})
}
