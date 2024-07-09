//
//  NotificationSectionModifier.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background()
            .continiousCornerRadius(.cornerRadius)
            .padding(.horizontal, .horizontalPadding)
    }
}

public extension View {
    func withNotificationSectionModifier() -> some View {
        modifier(NotificationSectionModifier())
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
}
