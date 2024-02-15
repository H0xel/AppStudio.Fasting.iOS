//
//  DiscountPaywallPinView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 12.02.2024.
//

import SwiftUI

struct DiscountPaywallPinView: View {
    let discountPercent: Int

    var body: some View {
        ZStack(alignment: .trailing) {
            Image(.discountPaywallPin)

            Text("-\(discountPercent)%")
                .font(.poppinsBold(18))
                .padding(.trailing, .trailingPadding)
                .padding(.top, .topPadding)
                .foregroundStyle(.white)
        }
    }
}

private extension CGFloat {
    static var topPadding: CGFloat { 3 }
    static var trailingPadding: CGFloat { 10 }
}

#Preview {
    DiscountPaywallPinView(discountPercent: 50)
}
