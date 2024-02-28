//
//  CoachEmptyView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI
import Dependencies
import AppStudioFoundation

struct CoachEmptyView: View {

    @Dependency(\.styles) private var styles

    var body: some View {
        ScrollView {
            VStack(spacing: .spacing) {
                Spacer(minLength: .topSpacing)
                CoachSenderMessageView(message: .initialMessageTermsNotAgree)
                MessageWithIconView(emoji: "🙅", text: .firstMessage)
                MessageWithIconView(emoji: "📑", text: .secondMessage)
                Spacer(minLength: .bottomSpacing)
            }
        }
        .scrollIndicators(.hidden)
        .background(styles.colors.coachGrayFillProgress)
    }
}


private extension String {
    static let firstMessage = "CoachScreen.messageWithIconText.first".localized(bundle: .coachBundle)
    static let secondMessage = "CoachScreen.messageWithIconText.second".localized(bundle: .coachBundle)
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let topSpacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 44
}

#Preview {
    CoachEmptyView()
}
