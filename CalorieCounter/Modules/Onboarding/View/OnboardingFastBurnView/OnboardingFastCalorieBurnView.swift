//
//  OnboardingFastCalorieBurnView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.01.2024.
//

import SwiftUI

struct OnboardingFastCalorieBurnView: View {
    @Binding var startPoint: CGFloat
    let outsideRange: ClosedRange<Double>
    let insideRange: ClosedRange<Double>
    let viewData: ViewData
    let isInitial: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                Text(isInitial ? Localization.fastCalorieBurnTitle : Localization.changeGoalTitle)
                    .font(.poppins(.headerM))
                    .foregroundStyle(.accent)
                    .padding(.top, .titleTopPadding)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, viewData.averageDailyCalories.underLineKcal == nil ?
                            .titleBottomPadding :
                            .titleBottomPaddingWithoutUnderLineKcal)

                VStack(spacing: .zero) {
                    OnboardingFastCalorieStatusView(status: status)

                    Text(Localization.burnPerWeek(viewData.burnPerWeek))
                        .font(.poppins(.headerM))
                        .padding(.bottom, .burnPerWeekBottomPadding)

                    HStack(alignment: .top, spacing: .zero) {

                        OnboardingFastCalorieDescriptionView(viewData: .averageDailyCalories(
                            strikeThroughKcal: viewData.averageDailyCalories.underLineKcal,
                            kcal: viewData.averageDailyCalories.kcal)
                        )
                        .padding(.leading, .descriptionViewHorizontalPadding)

                        Spacer()

                        OnboardingFastCalorieDescriptionView(viewData: .estimatedAchievementDate(
                            date: viewData.estimatedAchievementDate)
                        )
                        .padding(.trailing, .descriptionViewHorizontalPadding)
                    }
                    .padding(.bottom, .descriptionViewBottomPadding)
                }
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.cornerRadius)
            }
            .padding(.horizontal, .horizontalPadding)

            OnboardingCustomSlider(
                startPoint: $startPoint,
                outsideRange: outsideRange,
                insideRange: insideRange
            )
            .padding(.vertical, .sliderVerticalPadding)
            .padding(.horizontal, .sliderHorizontalPadding)

            if let description = viewData.description {
                Text(description)
                    .font(.poppins(.body))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, .descriptionHorizontalPadding)
                    .padding(.top, .descriptionTopPadding)
            }
            Spacer(minLength: .bottomPadding)
        }
        .scrollIndicators(.hidden)
    }

    private var status: OnboardingFastCalorieStatusView.Status {
        if viewData.isLessThenMinimum {
            return .minimumIntake
        }
        if insideRange.contains(startPoint) {
            return .recommended
        }
        if startPoint < insideRange.lowerBound {
            return .slower
        }
        return .faster
    }
}

extension OnboardingFastCalorieBurnView {
    struct ViewData {
        let burnPerWeek: String
        let averageDailyCalories: AverageDailyCalories
        let estimatedAchievementDate: String
        let description: String?
        let isLessThenMinimum: Bool

        struct AverageDailyCalories {
            let kcal: String
            let underLineKcal: String?
        }
    }
}

extension OnboardingFastCalorieBurnView.ViewData {
    static var mock: OnboardingFastCalorieBurnView.ViewData {
        .init(burnPerWeek: "-0.62 lb",
              averageDailyCalories: .init(kcal: "-1450",
                                          underLineKcal: nil),
              estimatedAchievementDate: "Feb 5, 2024",
              description: Localization.description2,
              isLessThenMinimum: false)
    }
}

private extension CGFloat {
    static var titleTopPadding: CGFloat { 24 }
    static var titleBottomPadding: CGFloat { 60 }
    static var titleBottomPaddingWithoutUnderLineKcal: CGFloat = 31
    static var burnPerWeekBottomPadding: CGFloat { 24 }

    static var descriptionViewHorizontalPadding: CGFloat = 27
    static var descriptionViewBottomPadding: CGFloat = 24
    static var cornerRadius: CGFloat { 20 }

    static var sliderVerticalPadding: CGFloat = 32
    static var sliderHorizontalPadding: CGFloat { 16 }
    static var descriptionHorizontalPadding: CGFloat = 52
    static var descriptionTopPadding: CGFloat = 32
    static var bottomPadding: CGFloat { 120 }

    static var horizontalPadding: CGFloat { 32 }
}

private enum Localization {
    static func burnPerWeek(_ amount: String) -> String {
        String(format: NSLocalizedString("OnboardingFastCalorieView.burnPerWeek", comment: ""), amount)
    }

    static let fastCalorieBurnTitle = NSLocalizedString("Onboarding.fastCalorieBurn.title", comment: "")
    static let changeGoalTitle = NSLocalizedString("Onboarding.fastCalorieBurn.changeGoalTitle", comment: "")
    static let description1 = NSLocalizedString("OnboardingFastCalorieView.description1", comment: "")
    static let description2 = NSLocalizedString("OnboardingFastCalorieView.description2", comment: "")
}

#Preview {
    OnboardingFastCalorieBurnView(startPoint: .constant(0.5),
                                  outsideRange: 0...1.5,
                                  insideRange: 0.3...1.2,
                                  viewData: .mock,
                                  isInitial: true)
}
