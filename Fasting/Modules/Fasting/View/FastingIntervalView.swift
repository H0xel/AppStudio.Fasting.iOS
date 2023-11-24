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
    let status: FastingStatus
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: Layout.spacing) {
            FastingTimeView(title: status.fastingStartDescription, time: fastStarts, onEdit: onEdit)
            FastingTimeView(title: status.isFinished
                            ? Localization.goalReached
                            : status.fastingEndDescription,
                            time: fastEnds)
        }
    }
}

private extension FastingIntervalView {
    enum Localization {
        static let goalReached: LocalizedStringKey = "StartFastingScreen.goalReached"
    }

    enum Layout {
        static let spacing: CGFloat = 8
    }
}

private extension FastingStatus {
    var fastingStartDescription: LocalizedStringKey {
        switch self {
        case .active: return "FastingIntervalView.fastingStarted"
        case .inActive: return "FastingIntervalView.fastingStarts"
        case .unknown: return ""
        }
    }

    var fastingEndDescription: LocalizedStringKey {
        switch self {
        case .active: return "FastingIntervalView.fastingEnds"
        case .inActive: return "FastingIntervalView.fastingEnd"
        case .unknown: return ""
        }
    }
}

#Preview {
    FastingIntervalView(
        fastStarts: "20:40",
        fastEnds: "13:40",
        status: .active(.init(interval: 30, stage: .autophagy, isFinished: false)),
        onEdit: {}
    )
}
