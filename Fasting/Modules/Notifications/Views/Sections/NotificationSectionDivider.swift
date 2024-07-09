//
//  NotificationSectionDivider.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.07.2024.
//

import SwiftUI

struct NotificationSectionDivider: View {
    var body: some View {
        Divider()
            .frame(height: .dividerHeight)
            .foregroundStyle(Color.studioGrayPlaceholder)
            .padding(.top, .topPadding)
    }
}

private extension CGFloat {
    static let dividerHeight: CGFloat = 1
    static let topPadding: CGFloat = 16
}

#Preview {
    NotificationSectionDivider()
}
