//
//  DailyCalorieBudgetOnboardingButtons.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI
import AppStudioUI

struct DailyCalorieBudgetButtonsView: View {

    let startButtonTitle: LocalizedStringKey
    let onPrevTap: (() -> Void)?
    let onStartTap: () -> Void

    var body: some View {
        HStack(spacing: .buttonSpacing) {
            if let onPrevTap {
                OnboardingPreviousPageButton(onTap: onPrevTap)
            }
            AccentButton(title: startButtonTitle, action: onStartTap)
        }
        .padding(.top, .buttonTopPadding)
        .padding(.bottom, .buttonBottomPadding)
        .padding(.horizontal, .horizontalPadding)
        .background(VisualEffect(style: .light).ignoresSafeArea())
        .aligned(.bottom)
    }
}

private extension CGFloat {
    static var buttonBottomPadding: CGFloat { 32 }
    static var buttonSpacing: CGFloat { 8 }
    static var horizontalPadding: CGFloat { 16 }
    static var buttonTopPadding: CGFloat { 16 }
}

#Preview {
    DailyCalorieBudgetButtonsView(startButtonTitle: "NextTitle", onPrevTap: {}, onStartTap: {})
}
