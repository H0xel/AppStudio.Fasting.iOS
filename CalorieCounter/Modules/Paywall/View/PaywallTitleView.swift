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
                .font(.poppins(.headerL))
                .foregroundStyle(.accent)
            Text(titles.description)
                .font(.poppins(.body))
                .foregroundColor(.studioGrayText)
        }
        .multilineTextAlignment(.center)
    }
}

private extension PaywallTitleView {
    enum Layout {
        static let spacing: CGFloat = 16
    }
}

struct PaywallTitleView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallTitleView(
            titles: PaywallTitle(
                title: "Reach your weight goals",
                description: "",
                subTitle: "Try 3 days for free, then $14.99/month"
            )
        )
    }
}
