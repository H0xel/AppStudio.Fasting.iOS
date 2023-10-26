//
//  PaywallBottomInfoView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 04.08.2023.
//

import SwiftUI
import AppStudioUI

struct PaywallBottomInfoView: View {
    let onSaveTap: () -> Void

    var body: some View {
        VStack(spacing: Layout.spacing) {
            PaywallCancelView()

            BaseButton(configuration: .init(title: Localization.continueTitle),
                       style: .primaryExtraLarge(.fill),
                       action: onSaveTap)
        }
    }
}

private extension PaywallBottomInfoView {
    enum Layout {
        static let spacing: CGFloat = 24
    }

    enum Localization {
        static let continueTitle = NSLocalizedString("Paywall.Continue", comment: "Continue")
    }
}

struct PaywallBottomInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallBottomInfoView {}
    }
}
