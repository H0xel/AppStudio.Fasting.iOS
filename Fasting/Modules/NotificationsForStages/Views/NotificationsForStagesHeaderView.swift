//
//  NotificationsForStagesHeaderView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import SwiftUI

struct NotificationsForStagesHeaderView: View {
    var body: some View {
        Text("NotificationsScreen.selectStages")
            .font(.poppins(.headerS))
            .padding(.top, .topPadding)
            .padding(.bottom, .bottomPadding)
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 32
    static let bottomPadding: CGFloat = 40
}

#Preview {
    NotificationsForStagesHeaderView()
}
