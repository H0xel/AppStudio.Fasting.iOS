//
//  PaywallBottomInfoView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 04.08.2023.
//

import SwiftUI
import AppStudioUI

struct PaywallBottomInfoView: View {
    let bottomInfo: LocalizedStringKey
    let action: (Action) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            PaywallCancelView()
            AccentButton(title: Localization.continueTitle) {
                action(.onSaveTap)
            }
            .padding(.top, Layout.buttonTopPadding)
            HStack(spacing: Layout.noPaymentsSpacing) {
                Image.checkmark
                    .foregroundStyle(.green)
                    .font(.subheadline)
                Text(bottomInfo)
                    .font(.poppins(.description))
            }
            .padding(.top, Layout.bottomTextTopPadding)
        }
    }
}

extension PaywallBottomInfoView {
    enum Action {
        case onSaveTap
    }
}

private extension PaywallBottomInfoView {
    enum Layout {
        static let noPaymentsSpacing: CGFloat = 4
        static let bottomTextTopPadding: CGFloat = 16
        static let buttonTopPadding: CGFloat = 20
    }

    enum Localization {
        static let continueTitle: LocalizedStringKey = "Paywall.Continue"
    }
}

struct PaywallBottomInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallBottomInfoView(bottomInfo: "Paywall.cancelAnyTime") { _ in }
            .padding(.horizontal, 32)
    }
}
