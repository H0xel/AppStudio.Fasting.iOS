//
//  ActiveFastingWidgetProgressView.swift
//
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
//

import SwiftUI

struct ActiveFastingWidgetProgressView: View {

    let state: ActiveFastingWidgetState

    @State private var viewWidth: CGFloat = 0

    var body: some View {
        ZStack(alignment: .trailing) {
            gradient
            Color.studioGreyFillProgress
                .frame(height: .lineHeight)
                .corners([.topRight, .bottomRight], with: .lineCornerRadius)
                .frame(width: viewWidth - gradientWidth)

            if let activePhase {
                Button(action: state.onCircleTap) {
                    Circle()
                        .fill(activePhase.backgroundColor)
                        .frame(width: .circleWidth)
                        .padding(.circleOuterPadding)
                        .background(
                            Color.white
                                .continiousCornerRadius(.circleBackgroundCornerRadius)
                        )
                        .overlay(activePhase.whiteImage)
                        .aligned(.left)
                        .offset(x: circleOffset)
                }
            }
        }
        .withViewWidthPreferenceKey
        .onViewWidthPreferenceKeyChange { newWidth in
            viewWidth = newWidth
        }
    }

    private var circleOffset: CGFloat {
        let circleWidth = .circleWidth + .circleOuterPadding
        if gradientWidth >= circleWidth {
            return min(gradientWidth - circleWidth, viewWidth - circleWidth)
        }
        return 0
    }

    private var gradientWidth: CGFloat {
        guard let maxInterval = state.phases.last?.timeRange.lowerBound else {
            return 0
        }
        let currentInterval = (-state.startDate.timeIntervalSinceNow)
        return min(currentInterval / maxInterval, 1) * viewWidth
    }

    private var activePhase: FastingWidgetPhase? {
        let interval = (-state.startDate.timeIntervalSinceNow)
        let phases = state.phases
        return phases.first(where: { $0.timeRange.contains(interval) })
    }

    private var gradient: some View {
        let colors = state.phases.map { $0.backgroundColor }
        return LinearGradient(colors: colors,
                       startPoint: .leading,
                       endPoint: .trailing)
        .frame(height: .lineHeight)
        .continiousCornerRadius(.lineCornerRadius)
    }
}

private extension CGFloat {
    static let lineHeight: CGFloat = 12
    static let lineCornerRadius: CGFloat = 48
    static let circleWidth: CGFloat = 40
    static let circleBackgroundCornerRadius: CGFloat = 23
    static let circleOuterPadding: CGFloat = 2
}

#Preview {
    ActiveFastingWidgetProgressView(state: .mock)
        .padding(.horizontal, 36)
}
