//
//  UsageLimitPaywallNavigationBar.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import SwiftUI

struct UsageLimitPaywallNavigationBar: View {

    let close: () -> Void
    let restore: () -> Void

    var body: some View {
        HStack {
            Button(action: close) {
                Image.close.foregroundStyle(Color.studioGreyPlaceholder)
            }
            Spacer()
            Button(action: restore) {
                Text(.restore)
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

private extension LocalizedStringKey {
    static let restore: LocalizedStringKey = "Paywall.restore"
}

#Preview {
    UsageLimitPaywallNavigationBar(close: {}, restore: {})
}
