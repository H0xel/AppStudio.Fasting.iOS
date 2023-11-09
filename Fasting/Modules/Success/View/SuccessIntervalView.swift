//
//  SuccessIntervalView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI

struct SuccessIntervalView: View {

    let startDate: String
    let endDate: String
    let onStartEdit: () -> Void
    let onEndEdit: () -> Void

    var body: some View {
        VStack(spacing: Layout.spacing) {
            SuccessIntervalButtonView(title: Localization.fastingStarted,
                                      date: startDate,
                                      roundedCorners: [.topLeft, .topRight],
                                      action: onStartEdit)
            SuccessIntervalButtonView(title: Localization.fastingEnded,
                                      date: endDate,
                                      roundedCorners: [.bottomLeft, .bottomRight],
                                      action: onEndEdit)
        }
    }
}

private extension SuccessIntervalView {
    enum Layout {
        static let spacing: CGFloat = 2
    }

    enum Localization {
        static let fastingStarted: LocalizedStringKey = "FastingIntervalView.fastingStarted"
        static let fastingEnded: LocalizedStringKey = "SuccessScreen.fastingEnded"
    }
}

#Preview {
    SuccessIntervalView(startDate: "October 10, 8:40 pm",
                        endDate: "Today, 11:09 am",
                        onStartEdit: {},
                        onEndEdit: {})
}
