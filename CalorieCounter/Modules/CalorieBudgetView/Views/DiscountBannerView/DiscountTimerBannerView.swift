//
//  DiscountTimerBannerView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import SwiftUI

struct DiscountTimerBannerView: View {
    let timerInterval: TimeInterval
    let discount: String

    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {

                Text("DiscountPaywall.limitedTimeOffer")
                    .font(.poppins(.headerS))
                    .padding(.vertical, .titleVerticalPadding)

                HStack(spacing: .timerSpacing) {
                    DiscountBannerDigitView(viewData: .init(digit: timerInterval.toDays, type: .days))
                    DiscountBannerDigitView(viewData: .init(digit: timerInterval.toHoursLeft, type: .hour))
                    DiscountBannerDigitView(viewData: .init(digit: timerInterval.toMinutes, type: .min))
                    DiscountBannerDigitView(viewData: .init(digit: timerInterval.toSeconds, type: .sec))
                    Spacer()
                }
            }

            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .overlay(
                        Triangle()
                            .fill(Color.studioRed)
                    )

                Text("-\(discount)")
                    .font(.poppins(.headerM))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(45))
                    .padding(.bottom, .discountPadding)
                    .padding(.leading, .discountPadding)
            }
            .frame(width: .discountFrame, height: .discountFrame)
        }
        .padding(.bottom, .bottomPadding)
    }
}

private extension CGFloat {
    static var titleVerticalPadding: CGFloat { 16 }
    static var timerSpacing: CGFloat { 8 }
    static var discountFrame: CGFloat { 109 }
    static var discountPadding: CGFloat { 40 }
    static var bottomPadding: CGFloat { 16 }
}

#Preview {
    DiscountTimerBannerView(timerInterval: .init(minutes: 15), discount: "50%")
        .background(.red)
}
