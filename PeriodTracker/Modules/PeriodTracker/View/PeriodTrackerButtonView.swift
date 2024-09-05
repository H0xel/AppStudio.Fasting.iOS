//
//  PeriodTrackerButtonView.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 05.09.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles

struct PeriodTrackerButtonView: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.poppinsMedium(.description))
                .foregroundStyle(Color.studioRed)
                .padding(.vertical, .verticalPadding)
                .padding(.horizontal, .horizontalPadding)
                .background(.white)
                .continiousCornerRadius(.cornerRadius)
        }
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 34
    static let cornerRadius: CGFloat = 44
}

#Preview {
    ZStack {
        Color.green
        PeriodTrackerButtonView(title: "Edit", action: {})
    }
}
