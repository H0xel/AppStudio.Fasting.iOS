//
//  OnboardingFastCalorieDescriptionView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI

struct OnboardingFastCalorieDescriptionView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .spacing) {
            switch viewData {
            case let .averageDailyCalories(strikeThroughKcal, kcal):
                if let strikeThroughKcal {
                    Text(Localization.kcal(strikeThroughKcal))
                        .font(.poppins(.body))
                        .foregroundStyle(.red)
                }

                Text(Localization.kcal(kcal))
                    .font(.poppins(.body))
                    .strikethrough(strikeThroughKcal != nil)

                Text(viewData.subtitle)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyText)

            case .estimatedAchievementDate(let date):
                Text(date)
                    .font(.poppins(.body))

                Text(viewData.subtitle)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyText)
            }
        }
        .multilineTextAlignment(.center)
        .frame(width: .width)
    }
}

extension OnboardingFastCalorieDescriptionView {
    enum ViewData {
        case averageDailyCalories(strikeThroughKcal: String?, kcal: String)
        case estimatedAchievementDate(date: String)

        var subtitle: String {
            switch self {
            case .averageDailyCalories: return Localization.averageDailyCalories
            case .estimatedAchievementDate: return Localization.estimatedAchievementDate
            }
        }
    }
}

private enum Localization {
    static func kcal(_ kcal: String) -> String {
        String(format: NSLocalizedString("OnboardingEstimatedExpenditureView.title", comment: ""), kcal)
    }

    static var averageDailyCalories = NSLocalizedString("OnboardingEstimatedExpenditureView.averageDaily",
                                                        comment: "")
    static var estimatedAchievementDate = NSLocalizedString("OnboardingEstimatedExpenditureView.estimatedAchievementDate",
                                                            comment: "")
}

private extension CGFloat {
    static var width: CGFloat { 132 }
    static var spacing: CGFloat { 8 }
}

#Preview {
    HStack(alignment: .top, spacing: 0) {
        OnboardingFastCalorieDescriptionView(viewData: .averageDailyCalories(strikeThroughKcal: "-1450", kcal: "-1450"))
        Spacer()
        OnboardingFastCalorieDescriptionView(viewData: .averageDailyCalories(strikeThroughKcal: nil, kcal: "-1450"))
        Spacer()
        OnboardingFastCalorieDescriptionView(viewData: .estimatedAchievementDate(date: "Feb 5, 2024"))
    }
}
