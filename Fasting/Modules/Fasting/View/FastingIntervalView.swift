//
//  FastingIntervalView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

struct FastingIntervalView: View {
    var body: some View {
        HStack(spacing: Layout.spacing) {
            FastingTimeView(title: Localization.fastingStarted, time: "20:40") {}
            FastingTimeView(title: Localization.fastingEnd, time: "13:40")
        }
    }
}

private extension FastingIntervalView {
    enum Localization {
        static let fastingStarted: LocalizedStringKey = "FastingIntervalView.fastingStarted"
        static let fastingEnd: LocalizedStringKey = "FastingIntervalView.fastingEnd"
    }

    enum Layout {
        static let spacing: CGFloat = 8
    }
}

#Preview {
    FastingIntervalView()
}
