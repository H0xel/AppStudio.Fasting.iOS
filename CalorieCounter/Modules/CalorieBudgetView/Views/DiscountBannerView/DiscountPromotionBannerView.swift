//
//  DiscountPromotionBannerView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import SwiftUI

struct DiscountPromotionBannerView: View {
    let discount: String
    var action: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text("DiscountPaywall.banner.get")

                ZStack {
                    Image(.discountPaywallPin)
                    Text(discount)
                        .foregroundStyle(.white)
                        .font(.poppins(.headerS))
                        .padding(.leading, .pinHorizontalPadding)
                }
                .padding(.horizontal, .pinHorizontalPadding)
                Text("DiscountPaywall.banner.off")
            }
            .font(.poppins(.headerS))
            .padding(.top, .topPadding)

            Spacer()

            Button(action: action) {
                Image.close
            }
            .padding(.top, .buttonTopPadding)
        }

        Text("DiscountPaywall.banner.description \(discount)")
            .font(.poppins(.body))
            .padding(.trailing, .descriptionTrailingPadding)
            .padding(.top, .descriptionTopPadding)
            .padding(.bottom, .descriptionBottomPadding)
    }
}

private extension CGFloat {
    static var pinHorizontalPadding: CGFloat { 8 }
    static var topPadding: CGFloat { 16 }
    static var buttonTopPadding: CGFloat { 12 }
    static var descriptionTopPadding: CGFloat { 8 }
    static var descriptionBottomPadding: CGFloat { 16 }
    static var descriptionTrailingPadding: CGFloat { 8 }
}

#Preview {
    DiscountPromotionBannerView(discount: "50%") {}
}