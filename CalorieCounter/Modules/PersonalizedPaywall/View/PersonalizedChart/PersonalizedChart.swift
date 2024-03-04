//
//  PersonalizedChart.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedChart: View {
    let viewData: ViewData

    var body: some View {
        ZStack {
            PersonalizedSeparatorView(endDate: viewData.endDate)

            Image(.vector)
                .resizable()
                .padding(.leading, Layout.vectorLeadingPadding)
                .padding(.trailing, Layout.vectorTrailingPadding)
                .padding(.top, Layout.vectorTopPadding)
                .padding(.bottom, Layout.vectorBottomPadding)

            PersonalizedStartWeightView(startWeight: viewData.startWeight)

            PersonalizedWeightDifferenceView(
                weightDifference: viewData.weightDifference,
                endWeight: viewData.endWeight
            )

            if viewData.specialEventStatus != .unavailable {
                PersonalizedSpecialEventView(
                    specialEventWithWeightTitle: viewData.specialEventWithWeightTitle,
                    specialEventDate: viewData.specialEventDate,
                    specialEventDateLaterThenEndDate: viewData.specialEventStatus == .isLaterThenEndDate
                )
            }
        }
        .frame(width: Layout.width, height: Layout.height)
        .background(Color.studioGrayFillCard)
        .continiousCornerRadius(Layout.cornerRadius)
    }
}

extension PersonalizedChart {
    struct ViewData {
        let startWeight: String
        let endWeight: String
        let weightDifference: String
        let endDate: String
        let specialEventWithWeightTitle: String
        let specialEventDate: String
        let specialEventStatus: SpecialEventStatus

        enum SpecialEventStatus {
            case unavailable
            case isLaterThenEndDate
            case isEarlierThenEndDate
        }
    }

    private enum Layout {
        static let cornerRadius: CGFloat = 20
        static let width: CGFloat = 320
        static let height: CGFloat = 200

        static let vectorTopPadding: CGFloat = 57
        static let vectorBottomPadding: CGFloat = 38
        static let vectorLeadingPadding: CGFloat = 24
        static let vectorTrailingPadding: CGFloat = 26
    }
}

#if DEBUG
#Preview {
    PersonalizedChart(viewData: .mock)
}

extension PersonalizedChart.ViewData {
    static var mock: PersonalizedChart.ViewData {
        .init(
            startWeight: "56 kg",
            endWeight: "52 kg",
            weightDifference: "- 4 kg",
            endDate: "Feb 14",
            specialEventWithWeightTitle: "Birthday 53 kg",
            specialEventDate: "Feb 13",
            specialEventStatus: .isLaterThenEndDate)
    }
}
#endif
