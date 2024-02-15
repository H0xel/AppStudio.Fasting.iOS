//
//  LockedViewPaywallButton.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 05.12.2023.
//

import SwiftUI

struct LockedViewPaywallButton: View {

    let onTap: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Image(.articleLocked)
            Spacer()
            Text(Localization.title)
                .font(.poppins(.headerM))
                .padding(.bottom, Layout.textSpacing)
            Text(Localization.description)
                .font(.poppins(.body))
            Spacer()
            AccentButton(title: .localizedString(Localization.buttonTitle), action: onTap)
            Spacer()
        }
        .multilineTextAlignment(.center)
    }
}

private extension LockedViewPaywallButton {

    enum Layout {
        static let textSpacing: CGFloat = 12
    }

    enum Localization {
        static let title: LocalizedStringKey = "LockedViewPaywallButton.title"
        static let description: LocalizedStringKey = "LockedViewPaywallButton.description"
        static let buttonTitle: LocalizedStringKey = "LockedViewPaywallButton.buttonTitle"
    }
}

#Preview {
    LockedViewPaywallButton {}
}
