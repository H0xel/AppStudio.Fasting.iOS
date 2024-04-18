//
//  UsageLimitPaywallNavigationBar.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import SwiftUI
import MunicornFoundation

struct UsageLimitPaywallNavigationBar: View {

    let action: (MultipleProductPaywallScreen.Event) -> Void

    var body: some View {
        HStack {
            Button(action: {
                action(.close)
            }) {
                Image.close.foregroundStyle(Color.studioGreyPlaceholder)
            }
            Spacer()
            Button(action: {
                action(.restore)
            }) {
                Text("Paywall.restore".localized(bundle: .module))
                    .foregroundColor(.studioGreyPlaceholder)
                    .font(.poppins(.buttonText))
            }
        }
        .padding(.horizontal, .horizoltalPadding)
        .padding(.top, UIDevice.safeAreaTopInset)
        .aligned(.top)
    }
}

private extension CGFloat {
    static let horizoltalPadding: CGFloat = 16
}

#Preview {
    UsageLimitPaywallNavigationBar(action: { _ in })
}
