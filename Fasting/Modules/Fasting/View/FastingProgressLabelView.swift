//
//  FastingProgressLabelView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 31.10.2023.
//

import SwiftUI

struct FastingProgressLabelView: View {

    let status: FastingStatus

    var body: some View {
        view
            .multilineTextAlignment(.center)
    }

    @ViewBuilder
    var view: some View {
        switch status {
        case .active(let fastingActiveState):
            VStack(spacing: Layout.labelsSpacing) {
                Text(Localization.youFastFor)
                    .font(.poppins(.body))
                FastingTimeIntervalView(timeInterval: fastingActiveState.interval)
            }
        case .inActive(let stage):
            switch stage {
            case .left(let timeInterval):
                VStack(spacing: Layout.labelsSpacing) {
                    Text(Localization.nextFasIn)
                        .font(.poppins(.body))
                    FastingTimeIntervalView(timeInterval: timeInterval)
                }
            case .expired:
                Text(Localization.readyToFast)
                    .font(.poppins(.accentS))
            }
        case .unknown:
            Text("")
        }
    }
}

private extension FastingProgressLabelView {
    enum Localization {
        static let nextFasIn: LocalizedStringKey = "FastingProgressView.nextFastIn"
        static let readyToFast: LocalizedStringKey = "FastingProgressView.readyToFast"
        static let youFastFor: LocalizedStringKey = "FastingProgressView.youFastFor"
    }

    enum Layout {
        static let labelsSpacing: CGFloat = 10
    }
}

#Preview {
    FastingProgressLabelView(status: .active(.init(interval: 0, stage: .autophagy, isFinished: false)))
}
