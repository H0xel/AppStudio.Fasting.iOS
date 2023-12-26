//
//  FastingRingActiveStateView.swift
//  Fasting
//
//  Created by Denis Khlopin on 28.11.2023.
//

import SwiftUI

struct FastingRingActiveStateView: View {
    let interval: TimeInterval
    let plan: FastingPlan
    let settings: FastingRingSettings
    let hasSubscription: Bool
    let onTapStage: (FastingStage) -> Void

    var body: some View {
        ZStack {
            Circle()
                .trim(from: settings.trimRange.lowerBound, to: data.currentPosition)
                .stroke(gradient, style: StrokeStyle(lineWidth: settings.borderWidth, lineCap: .round))

            ForEach(data.stagePoints, id: \.stage) { point in
                FastingRingPointCircleView(
                    radius: settings.radius,
                    point: point,
                    hasSubscription: hasSubscription || point.stage == data.stagePoints.first?.stage,
                    onTapStage: onTapStage
                )
                .position(.init(x: point.center.x, y: point.center.y))
                .frame(width: settings.borderWidth)
            }
        }
    }

    private var data: FastingRingActiveStateData {
        fastingRingActiveStateData()
    }

    private var gradientStopPoints: [Gradient.Stop] {
        data.stagePoints.map { .init(color: $0.color, location: $0.gradientPosition) }
    }

    private var gradient: AngularGradient {
        AngularGradient(stops: gradientStopPoints, center: .center)
    }

    private func fastingRingActiveStateData() -> FastingRingActiveStateData {
        let totalDuration = plan.duration
        let availableStages = FastingStage.allCases
            .filter { stage in
                stage.startHour <= totalDuration
            }
            .sorted { $0.startHour < $1.startHour }

        guard let firstHour = availableStages.first?.startHour, availableStages.count > 1 else {
            return FastingRingActiveStateData(currentPosition: 0, stagePoints: [])
        }
        let hoursRange = firstHour ... plan.duration

        let stagePoints = availableStages
            .map { stage in
                let angle = stage.startHour.scale(from: hoursRange, to: settings.angleRange)
                let gradientPosition = stage.startHour.scale(from: hoursRange, to: settings.trimRange)
                let centerPoint = CGPoint(
                    x: (settings.radius * cos(angle) + settings.centerPoint.x) + settings.borderWidth / 2,
                    y: settings.radius * sin(angle) + settings.centerPoint.y
                )

                return FastingStagePoint(stage: stage,
                                         angle: angle,
                                         gradientPosition: gradientPosition,
                                         color: stage.backgroundColor,
                                         isSelected: interval > stage.startHour,
                                         center: centerPoint)
            }

        let currentPosition = min(interval, hoursRange.upperBound).scale(from: hoursRange, to: settings.trimRange)

        return FastingRingActiveStateData(currentPosition: currentPosition, stagePoints: stagePoints)
    }
}
