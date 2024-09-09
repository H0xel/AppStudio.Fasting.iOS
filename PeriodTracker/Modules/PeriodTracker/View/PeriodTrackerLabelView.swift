//
//  PeriodTrackerLabelView.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 05.09.2024.
//

import SwiftUI
import AppStudioUI

struct PeriodTrackerLabelView: View {

    let text: String

    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .font(.poppins(.description))
            .padding(.vertical, .verticalPadding)
            .padding(.horizontal, .horizontalPadding)
            .background(.white.opacity(0.15))
            .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 56
}

#Preview {
    ZStack {
        Color.red
        PeriodTrackerLabelView(text: "Low chances of getting pregnant")
    }
}
