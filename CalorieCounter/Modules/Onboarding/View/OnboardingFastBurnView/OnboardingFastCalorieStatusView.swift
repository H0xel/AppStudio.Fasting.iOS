//
//  OnboardingFastCalorieStatusView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI

struct OnboardingFastCalorieStatusView: View {
    let status: OnboardingFastCalorieStatusView.Status

    var body: some View {
        HStack(spacing: .zero) {
            Spacer()
            Text(status.title)
                .font(.poppins(.body))
                .foregroundStyle(.white)
                .padding(.horizontal, .titleHorizontalPadding)
                .padding(.vertical, .titleVerticalPadding)
                .background(status.backgroundColor)
                .continiousCornerRadius(.cornerRadius)
            Spacer()
        }
        .padding(.vertical, .verticalPadding)
    }
}

extension OnboardingFastCalorieStatusView {
    enum Status: String {
        case recommended
        case slower
        case faster
        case minimumIntake

        var backgroundColor: Color {
            switch self {
            case .recommended: return .studioGreen
            case .slower, .faster: return .studioPurple
            case .minimumIntake: return .studioRed
            }
        }

        var title: String {
            NSLocalizedString("OnboardingFastCalorieView.\(self.rawValue)", comment: "")
        }
    }
}

private extension CGFloat {
    static var titleHorizontalPadding: CGFloat { 16 }
    static var titleVerticalPadding: CGFloat { 10 }
    static var cornerRadius: CGFloat { 56 }
    static var verticalPadding: CGFloat { 24 }
}

#Preview {
    OnboardingFastCalorieStatusView(status: .recommended)
}
