//
//  FastingIntervalView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

struct FastingIntervalView: View {

    let fastStarts: String
    let fastEnds: String
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: Layout.spacing) {
            FastingTimeView(title: Localization.fastingStarted, time: fastStarts, onEdit: onEdit)
            FastingTimeView(title: Localization.fastingEnd, time: fastEnds)
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
    FastingIntervalView(fastStarts: "20:40", fastEnds: "13:40", onEdit: {})
}
