//
//  PaywallCancelView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 03.08.2023.
//

import SwiftUI

struct PaywallCancelView: View {
    var body: some View {
        Text(Localization.title)
            .font(.poppins(.body))
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension PaywallCancelView {
    enum Localization {
        static let title: LocalizedStringKey = "Paywall.cancelTitle"
    }
}

struct PaywallCancelView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallCancelView()
    }
}
