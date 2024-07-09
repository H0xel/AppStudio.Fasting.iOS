//
//  NotificationBottomView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 19.06.2024.
//

import SwiftUI

struct NotificationBottomView: View {
    let action: (Action) -> Void

    var body: some View {
        HStack(spacing: .spacing) {
            OnboardingPreviousPageButton(type: .text("SkipTitle")) {
                action(.skip)
            }
            AccentButton(title: .localizedString("SaveTitle")) {
                action(.save)
            }
        }
        .padding(.top, .topPadding)
        .padding(.horizontal, .horizontalPadding)
        .padding(.bottom, .bottomPadding)
        .background()
    }
}

extension NotificationBottomView {
    enum Action {
        case skip
        case save
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let topPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 8
}

#Preview {
    NotificationBottomView() { _ in }
}
