//
//  PeriodTrackerCurrentPeriodView.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 05.09.2024.
//

import SwiftUI

struct PeriodTrackerCurrentPeriodView: View {

    let configuration: PeriodConfiguration
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Text("\(configuration.numberOfDays)")
                .font(.poppinsBold(58))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
            Text(configuration.subtitle)
                .font(.poppinsBold(.buttonText))
                .foregroundStyle(.white)
                .padding(.top, .subtitleTopPadding)
            PeriodTrackerLabelView(text: configuration.labelText)
                .padding(.top, .labelTopPadding)
            PeriodTrackerButtonView(title: configuration.buttonText,
                                    action: onTap)
            .padding(.top, .buttonTopPadding)
        }
        .padding(.vertical, .verticalPadding)
        .background(
            LinearGradient(stops: configuration.gradientColors,
                           startPoint: .leading,
                           endPoint: .trailing)
        )
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 53
    static let cornerRadius: CGFloat = 56
    static let subtitleTopPadding: CGFloat = 4
    static let labelTopPadding: CGFloat = 16
    static let buttonTopPadding: CGFloat = 32
}

#Preview {
    PeriodTrackerCurrentPeriodView(
        configuration: .period(daysUntil: 3),
        onTap: {}
    )
}
