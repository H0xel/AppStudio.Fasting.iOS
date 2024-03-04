//
//  PersonalizedPromotionalOfferView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 13.02.2024.
//

import SwiftUI

struct PersonalizedPromotionalOfferView: View {
    let viewData: ViewData

    var body: some View {
        ZStack {
            LinearGradient(colors: [.studioOrange, .studioRed],
                           startPoint: .leading,
                           endPoint: .trailing)
            HStack {
                Spacer()
                VStack(spacing: .zero) {
                    Text(viewData.duration)
                        .font(.poppins(.headerS))
                    Text(viewData.price)
                        .font(.poppinsBold(15))
                }
                .foregroundStyle(.white)
                .padding(.top, .topPadding)
                .padding(.bottom, .bottomPadding)
                Spacer()
            }
        }
        .frame(width: .width)
        .continiousCornerRadius(.cornerRadius)
    }
}

extension PersonalizedPromotionalOfferView {
    struct ViewData {
        let duration: String
        let price: String
    }
}

private extension CGFloat {
    static var topPadding: CGFloat { 12 }
    static var bottomPadding: CGFloat { 11 }
    static var cornerRadius: CGFloat { 16 }
    static var width: CGFloat { 320 }
}

extension PersonalizedPromotionalOfferView.ViewData {
    static var mock: PersonalizedPromotionalOfferView.ViewData {
        .init(duration: "1 month", price: "$0.99")
    }
}

#Preview {
    PersonalizedPromotionalOfferView(viewData: .mock)
}
