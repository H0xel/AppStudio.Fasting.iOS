//
//  PersonalizedSpecialEventView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedSpecialEventView: View {
    let specialEventWithWeightTitle: String
    let specialEventDate: String
    let specialEventDateLaterThenEndDate: Bool

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text(specialEventWithWeightTitle)
                    .padding(.horizontal, Layout.specialEventHorizontalPadding)
                    .padding(.vertical, Layout.specialEventVerticalPadding)
                    .foregroundStyle(.white)
                    .font(.poppins(.description))
                    .background(Color.studioRed)
                    .continiousCornerRadius(Layout.specialEventCornerRadius)

                if specialEventDateLaterThenEndDate {
                    Image(.arrow)
                }
            }

            if !specialEventDateLaterThenEndDate {
                Image(.separator)
                    .resizable()
                    .frame(width: Layout.specialEventSeparatorWidth)
                    .padding(.bottom, Layout.specialEventSeparatorBottomPadding)

                Text(specialEventDate)
                    .font(.poppins(.description))
                    .padding(.bottom, Layout.specialEventDateBottomPadding)
            } else {
                Spacer()
            }
        }
        .aligned(.right)
        .padding(.top, Layout.specialEventTopPadding)
        .padding(.trailing, specialEventDateLaterThenEndDate
                 ? Layout.specialEventTrailingWhenEventIsEarlier
                 : Layout.specialEventTrailingWhenEventIsLater
        )
    }
}

private extension PersonalizedSpecialEventView {
    enum Layout {
        static let specialEventTopPadding: CGFloat = 25
        static let specialEventTrailingWhenEventIsLater: CGFloat = 45
        static let specialEventTrailingWhenEventIsEarlier: CGFloat = 26
        static let specialEventDateBottomPadding: CGFloat = 20
        static let specialEventSeparatorWidth: CGFloat = 2
        static let specialEventSeparatorBottomPadding: CGFloat = 11
        static let specialEventCornerRadius: CGFloat = 8
        static let specialEventVerticalPadding: CGFloat = 6
        static let specialEventHorizontalPadding: CGFloat = 12
    }
}

#Preview {
    PersonalizedSpecialEventView(
        specialEventWithWeightTitle: "Birthday 53 kg",
        specialEventDate: "13 Feb",
        specialEventDateLaterThenEndDate: false
    )
}
