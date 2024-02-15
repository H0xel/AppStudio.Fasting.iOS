//
//  DiscountDescriptionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI

struct DiscountDescriptionView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {

            switch viewData {
            case let .perWeek(weekPrice, pricePerYear, discountPricePerYear, color):
                HStack(alignment: viewData.alignment, spacing: .spacing) {
                    Text(.only)
                        .font(.poppinsBold(18))
                    VStack(spacing: .zero) {
                        Text(weekPrice)
                            .foregroundStyle(color)
                            .font(viewData.font)
                    }

                    Text(.week)
                        .font(.poppinsBold(18))
                }

                HStack(spacing: .yearDiscountSpacing) {
                    Text(pricePerYear)
                        .font(.poppins(.body))
                        .foregroundStyle(.fastingGrayText)
                        .strikethrough(true)

                    Text(discountPricePerYear)
                        .font(.poppins(.body))
                        .foregroundStyle(.fastingGrayText)
                }

            case let .oldNew(price, discountPrice, duration, color):
                HStack(alignment: viewData.alignment, spacing: .spacing) {
                    Text(.only)
                        .font(.poppinsBold(18))
                    VStack(spacing: .zero) {
                        Text(discountPrice)
                            .foregroundStyle(color)
                            .font(viewData.font)

                        Text(price)
                            .strikethrough(true)
                            .padding(.top, .topPadding)
                            .foregroundStyle(Color.fastingGreyStrokeFill)
                            .font(viewData.font)
                    }

                    Text("/ \(duration)")
                        .font(.poppinsBold(18))
                }
            }
        }
    }
}

extension DiscountDescriptionView {

    enum ViewData {
        case perWeek(weekPrice: String, pricePerYear: String, discountPricePerYear: String, color: Color)
        case oldNew(price: String, discountPrice: String, duration: String, color: Color)

        var font: Font {
            switch self {
            case .perWeek: return .poppins(.accentS)
            case .oldNew: return .poppins(.headerL)
            }
        }

        var alignment: VerticalAlignment {
            switch self {
            case .perWeek: return .lastTextBaseline
            case .oldNew: return .center
            }
        }
    }
}

private extension LocalizedStringKey {
    static var only: LocalizedStringKey { "DiscountPaywall.only" }
    static var week: LocalizedStringKey { "DiscountPaywall.week" }
}

private extension CGFloat {
    static var topPadding: CGFloat { -10 }
    static var spacing: CGFloat { 12 }
    static var yearDiscountSpacing: CGFloat { 6 }
}

extension DiscountDescriptionView.ViewData {
    static var mock: DiscountDescriptionView.ViewData {
        .perWeek(weekPrice: "$2.99",
                 pricePerYear: "$199.99",
                 discountPricePerYear: "$39.99 per year",
                 color: .fastingRed)
    }
}

struct DiscountDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DiscountDescriptionView(viewData: .mock)
    }
}
