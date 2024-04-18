//
//  FinishedFastingWidgetTimeView.swift
//
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI

struct FinishedFastingWidgetTimeView: View {

    let state: FinishedFastingWidgetState

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .horizontalSpacing) {
                Text(fastingTime)
                    .font(.poppins(.headerM))
                    .foregroundStyle(Color.studioBlackLight)
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
                if let phase = state.finishPhase {
                    phase.coloredImage
                        .aligned(.left)
                }
            }
            HStack(spacing: .horizontalSpacing) {
                Text(fastingInterval)
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
                if let phase = state.finishPhase {
                    Text(phase.title)
                        .aligned(.left)
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.poppins(.description))
            .foregroundStyle(Color.studioBlackLight)
        }
    }

    private var fastingTime: String {
        state.finishedDate.timeIntervalSince(state.startDate).toTime
    }

    private var fastingInterval: String {
        let start = state.startDate.currentLocaleFormatted(with: "hh:mm")
        let end = state.finishedDate.currentLocaleFormatted(with: "hh:mm")
        return "\(start) - \(end)"
    }
}

private extension CGFloat {
    static let horizontalSpacing: CGFloat = 16
}

#Preview {
    FinishedFastingWidgetTimeView(state: .mockFinished)
}
