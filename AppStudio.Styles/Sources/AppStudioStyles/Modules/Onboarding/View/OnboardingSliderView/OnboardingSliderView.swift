//
//  OnboardingSliderView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.01.2024.
//

import SwiftUI

public struct OnboardingSliderView: View {
    @Binding var startPoint: CGFloat
    let outsideRange: ClosedRange<Double>
    let insideRange: ClosedRange<Double>
    let viewData: ViewData

    public init(startPoint: Binding<CGFloat>,
                outsideRange: ClosedRange<Double>,
                insideRange: ClosedRange<Double>,
                viewData: ViewData) {
        self._startPoint = startPoint
        self.outsideRange = outsideRange
        self.insideRange = insideRange
        self.viewData = viewData
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                Text(viewData.title)
                    .font(.poppins(.headerM))
                    .foregroundStyle(Color.studioBlackLight)
                    .padding(.top, .titleTopPadding)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, .titleBottomPadding)

                VStack(spacing: .zero) {
                    OnboardingFastCalorieStatusView(viewData: viewData.statusViewData)

                    Text(viewData.statusAmount)
                        .font(.poppins(.headerM))
                        .padding(.bottom, .burnPerWeekBottomPadding)

                    Text(viewData.statusDescription)
                        .font(.poppins(.body))
                        .padding(.bottom, .descriptionViewBottomPadding)
                }
                .padding(.horizontal, 24)
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.cornerRadius)
                .multilineTextAlignment(.center)
            }

            OnboardingCustomSlider(
                startPoint: $startPoint,
                outsideRange: outsideRange,
                insideRange: insideRange
            )
            .padding(.vertical, .sliderVerticalPadding)

            if let description = viewData.description {
                Text(description)
                    .font(.poppins(.body))
                    .foregroundStyle(Color.studioGrayText)
                    .multilineTextAlignment(.center)
                    .padding(.top, .descriptionTopPadding)
            }
            Spacer(minLength: .bottomPadding)
        }
        .scrollIndicators(.hidden)
    }
}

public extension OnboardingSliderView {
    struct ViewData {
        let title: String
        let statusViewData: OnboardingFastCalorieStatusView.ViewData
        let statusAmount: String
        let statusDescription: String
        let description: String?

        public init(title: String, 
                    statusViewData: OnboardingFastCalorieStatusView.ViewData,
                    statusAmount: String,
                    statusDescription: String,
                    description: String?
        ) {
            self.title = title
            self.statusViewData = statusViewData
            self.statusAmount = statusAmount
            self.statusDescription = statusDescription
            self.description = description
        }
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

#Preview {
    OnboardingSliderView(
        startPoint: .constant(4),
        outsideRange: 0...20,
        insideRange: 3...17,
        viewData: .init(
            title: "How long does your period usually last?",
            statusViewData: .init(
                title: "Normal",
                backgroundColor: Color.studioGreen
            ),
            statusAmount: "5",
            statusDescription: "Most periods last between 3 to 7 days, so you're right on track!",
            description: "Move  bar to select the number\nof days"
        )
    )
}
