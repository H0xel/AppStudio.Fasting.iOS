//
//  PaywallCancelView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 03.08.2023.
//

import SwiftUI

struct PaywallCancelView: View {
    var body: some View {
        VStack(spacing: Layout.spacing) {
            Text(Localization.title)
                .font(.poppins(.body))
                .foregroundStyle(.accent)
            Text(Localization.subtitle)
                .font(.poppins(.description))
                .foregroundColor(.fastingGrayText)
                .multilineTextAlignment(.center)
        }
    }
}

private extension PaywallCancelView {
    enum Layout {
        static let spacing: CGFloat = 12
    }

    enum Localization {
        static let title: LocalizedStringKey = "Paywall.cancelTitle"
        static let subtitle: LocalizedStringKey = "Paywall.cancelSubtitle"
    }
}

struct PaywallCancelView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallCancelView()
    }
}
