//
//  FastingRingView.swift
//  Fasting
//
//  Created by Denis Khlopin on 28.11.2023.
//

import SwiftUI

struct FastingRingView: View {
    let status: FastingStatus
    let plan: FastingPlan
    let hasSubscription: Bool
    let onTapStage: (FastingStage) -> Void
    let settings: FastingRingSettings = .default

    var body: some View {
        ZStack {
            Circle()
                .trim(from: settings.trimRange.lowerBound,
                      to: settings.trimRange.upperBound)
                .stroke(Color.fastingGrayFillProgress,
                        style: StrokeStyle(lineWidth: settings.borderWidth,
                                           lineCap: .round))

            if case let .active(fastingActiveState) = status {
                FastingRingActiveStateView(
                    interval: fastingActiveState.interval,
                    plan: plan,
                    settings: settings,
                    hasSubscription: hasSubscription,
                    onTapStage: onTapStage
                )
            }
        }
        .rotationEffect(Layout.rotationAngle)
        .frame(width: settings.totalWidth, height: settings.totalWidth)
    }

    private var backgroundColor: Color {
        switch status {
        case .active(let state):
            return state.stage.backgroundColor
        case .inActive:
            return .fastingGrayFillProgress
        case .unknown:
            return .fastingGrayFillProgress
        }
    }
}

private extension FastingRingView {
    enum Layout {
        static let rotationAngle: Angle = .degrees(90)
    }
}
