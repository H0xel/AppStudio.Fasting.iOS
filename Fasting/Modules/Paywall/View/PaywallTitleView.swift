//
//  PaywallTitleView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 04.08.2023.
//

import SwiftUI

struct PaywallTitleView: View {

    let titles: PaywallTitle

    var body: some View {
        VStack(spacing: Layout.spacing) {
            Text(titles.title)
//                .font(.poppins(.title).bold())
            Text(titles.description)
                .foregroundColor(.secondaryLabel)
            Text(titles.subTitle)
                .foregroundColor(.secondaryLabel)
                .font(.poppins(.body))
        }
    }
}

private extension PaywallTitleView {
    enum Localization {
        static let title: LocalizedStringKey = "Paywall.title"
        static let noPaymentsNow: LocalizedStringKey = "Paywall.noPaymentNow"
    }

    enum Layout {
        static let spacing: CGFloat = 12
    }
}

struct PaywallTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallTitleView(
            titles: PaywallTitle(
                title: "Title",
                description: "Try 3 days for free, then $14.99/month",
                subTitle: "no payments"
            )
        )
    }
}
