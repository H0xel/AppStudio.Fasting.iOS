//
//  DiscountPaywallView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI

struct DiscountPaywallView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                Text(.specialOffer)
                    .font(.poppins(.body))
                    .padding(.vertical, .specialOfferVerticalPadding)
                    .padding(.horizontal, .specialOfferHorizontallPadding)
                    .background(Color.fastingSpecialOffer)
                    .continiousCornerRadius(.cornerRadius)
                    .padding(.top, .specialOfferTopPadding)

                Text(LocalizedStringKey.discountOff(amount: viewData.discountAmount))
                    .font(.poppins(.accentS))
                    .padding(.top, .discountTopPadding)
                    .padding(.bottom, .discountBottomPadding)

                Text(LocalizedStringKey.getItNow)
                    .font(.poppins(.body))
                    .padding(.bottom, .endOfferBottomPadding)
            }
            .foregroundStyle(.white)
            .aligned(.centerHorizontaly)
            .background(Color.fastingRed)
            .continiousCornerRadius(.cornerRadius)
            .padding(.horizontal, .horizontalPadding)

            DiscountDescriptionView(viewData: viewData.descriptionViewData)
                .padding(.top, .descriptionTopPadding)
        }

        VStack(spacing: .zero) {
            Image(.discountTop)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Image(.discountBottom)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .ignoresSafeArea()
    }
}

extension DiscountPaywallView {
    struct ViewData {
        let discountAmount: String
        let descriptionViewData: DiscountDescriptionView.ViewData
    }
}

extension DiscountPaywallView.ViewData {
    static var mock: DiscountPaywallView.ViewData {
        .init(discountAmount: "50%", descriptionViewData: .mock)
    }
}

private extension LocalizedStringKey {
    static var specialOffer: LocalizedStringKey { "DiscountPaywall.specialOffer" }
    static func discountOff(amount: String) -> String {
        String(format: NSLocalizedString("DiscountPaywall.discountOff", comment: "OFF"), amount)
    }
    static var getItNow: LocalizedStringKey { "DiscountPaywall.unlimitedAccess" }
}

private extension CGFloat {
    static var specialOfferVerticalPadding: CGFloat { 8 }
    static var specialOfferHorizontallPadding: CGFloat { 16 }
    static var specialOfferTopPadding: CGFloat { 24 }

    static var discountTopPadding: CGFloat { 40 }
    static var discountBottomPadding: CGFloat { 6 }

    static var endOfferBottomPadding: CGFloat { 82 }
    static var descriptionTopPadding: CGFloat { 40 }

    static var cornerRadius: CGFloat { 40 }
    static var horizontalPadding: CGFloat { 24 }
}

#Preview {
    DiscountPaywallView(viewData: .mock)
}
