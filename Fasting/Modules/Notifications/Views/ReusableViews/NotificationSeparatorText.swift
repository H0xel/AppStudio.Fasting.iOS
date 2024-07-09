//
//  NotificationSeparatorText.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationSeparatorText: View {
    let text: LocalizedStringKey

    var body: some View {
        Text(text)
            .aligned(.left)
            .padding(.vertical, .verticalPadding)
            .font(.poppinsMedium(.body))
            .padding(.leading, .leadingPadding)
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 16
    static let leadingPadding: CGFloat = 36
}

#Preview {
    NotificationSeparatorText(text: "NotificationsScreen.separatorText.reminders")
}
