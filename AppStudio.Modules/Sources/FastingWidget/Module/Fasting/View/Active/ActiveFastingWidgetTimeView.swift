//
//  ActiveFastingWidgetTimeView.swift
//
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
//

import SwiftUI

struct ActiveFastingWidgetTimeView: View {

    let state: ActiveFastingWidgetState

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .horizontalSpacing) {
                Text(fastingTime)
                    .font(.poppins(.headerM))
                    .foregroundStyle(Color.studioBlackLight)
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
                Text(fastTime)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioGreyText)
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
            }
            HStack(spacing: .horizontalSpacing) {
                Text(currentPhase)
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
                Text("\(.until) \(finishTime)")
                    .aligned(.left)
                    .frame(maxWidth: .infinity)
            }
            .font(.poppins(.description))
            .foregroundStyle(Color.studioBlackLight)
        }
    }

    private var fastTime: String {
        let hours = (state.finishDate.timeIntervalSince(state.startDate)).hours
        return String(format: .fastTime, hours)
    }

    private var fastingTime: String {
        (-state.startDate.timeIntervalSinceNow).toTime
    }

    private var finishTime: String {
        state.finishDate.currentLocaleFormatted(with: "EEEE HH:mm")
    }

    private var currentPhase: String {
        let interval = (-state.startDate.timeIntervalSinceNow)
        let phases = state.phases
        return phases.first(where: { $0.timeRange.contains(interval) })?.title ?? ""
    }
}

private extension String {
    static let fastTime = "FastingWidgetView.fastTime".localized(bundle: .module)
    static let until = "FastingWidgetView.until".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalSpacing: CGFloat = 16
}

#Preview {
    ActiveFastingWidgetTimeView(state: .mock)
}
