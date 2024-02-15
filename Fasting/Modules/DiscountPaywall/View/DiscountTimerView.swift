//
//  DiscountTimerView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI

struct DiscountTimerView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            Image(.timerTop)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Image(.timerBottom)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .ignoresSafeArea()

        VStack(spacing: .zero) {
            Text(.limitedTimeOffer)
                .font(.poppins(.body))
                .foregroundStyle(.white)
                .padding(.horizontal, .offerHorizontalPadding)
                .padding(.vertical, .offerVerticalPadding)
                .background(Color.fastingRed)
                .continiousCornerRadius(.cornerRadius)
                .padding(.bottom, .offerBottomPadding)

            Text(LocalizedStringKey.discountOff(amount: viewData.discount))
                .font(.poppins(.accentS))
                .padding(.top, .discountTopPadding)

            HStack(spacing: .timerSpacing) {
                DiscountTimerElementView(viewData: .init(digit: viewData.timerInterval.toDays, type: .days))
                DiscountTimerElementView(viewData: .init(digit: viewData.timerInterval.toHoursLeft, type: .hour))
                DiscountTimerElementView(viewData: .init(digit: viewData.timerInterval.toMinutes, type: .min))
                DiscountTimerElementView(viewData: .init(digit: viewData.timerInterval.toSeconds, type: .sec))
            }
            .padding(.vertical, .timerVerticalPadding)

            DiscountDescriptionView(viewData: viewData.descriptionViewData)
        }
    }
}

extension DiscountTimerView {
    struct ViewData {
        var timerInterval: TimeInterval
        let discount: String
        let descriptionViewData: DiscountDescriptionView.ViewData
    }
}

extension DiscountTimerView.ViewData {
    static var mock: DiscountTimerView.ViewData {
        .init(
            timerInterval: .day + .hour * 4 + .minute * 45 + .second * 57,
            discount: "50%",
            descriptionViewData: .mock
        )
    }
}


private extension LocalizedStringKey {
    static var limitedTimeOffer: LocalizedStringKey { "DiscountPaywall.limitedTimeOffer" }
    static func discountOff(amount: String) -> String {
        String(format: NSLocalizedString("DiscountPaywall.discountOff", comment: "OFF"), amount)
    }
}

private extension CGFloat {
    static var offerHorizontalPadding: CGFloat { 16 }
    static var offerVerticalPadding: CGFloat { 8 }
    static var offerBottomPadding: CGFloat { 8 }
    static var cornerRadius: CGFloat { 8 }

    static var discountTopPadding: CGFloat { 12 }
    static var timerSpacing: CGFloat { 4 }
    static var timerVerticalPadding: CGFloat { 40 }
}

#Preview {
    DiscountTimerView(viewData: .mock)
}
