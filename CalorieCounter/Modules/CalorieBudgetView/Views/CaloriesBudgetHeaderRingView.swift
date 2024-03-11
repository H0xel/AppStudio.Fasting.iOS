//
//  CaloriesBudgetHeaderRingView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 09.01.2024.
//

import SwiftUI

struct CaloriesBudgetHeaderRingView: View {
    let calories: Double
    let title: String
    let trimPercent: CGFloat

    @State private var trimPercentValue: CGFloat = 0
    @Environment(\.isCurrentTab) private var isCurrentTab
    @Environment(\.id) private var id

    var body: some View {
        ZStack {
            Circle()
                .stroke(isOver ? Color.clear : Color.studioBlackLight.opacity(0.1),
                        style: StrokeStyle(lineWidth: .circleBorderWidth, lineCap: .round))
                .frame(width: .circleSize, height: .circleSize)

            Circle()
                .trim(from: trimFrom, to: trimTo)
                .stroke(gradient,
                        style: StrokeStyle(lineWidth: .circleBorderWidth, lineCap: .round))
                .rotationEffect(.degrees(rotationAngle))
                .frame(width: .circleSize, height: .circleSize)

            CaloriesBudgetHeaderLabelView(calories: calories,
                                          title: title,
                                          isLargeHeader: true)
        }
        .frame(width: .totalSize, height: .totalSize)
        .onChange(of: isCurrentTab) { isCurrentTab in
            setTrimValue(isCurrentTab: isCurrentTab)
        }
        .onChange(of: id) { _ in
            setTrimValue(isCurrentTab: isCurrentTab)
        }
    }

    private var isOver: Bool {
        trimPercentValue > 1.0
    }

    private var gradient: AngularGradient {
        isOver
        ? AngularGradient(
            stops: [
                .init(color: .white.opacity(0.02), location: 0.01),
                .init(color: .white, location: 1)
            ],
            center: .center
        )
        : AngularGradient(
            stops: [
                .init(color: .white, location: 0),
                .init(color: .white, location: 1)
            ],
            center: .center
        )
    }

    private var trimTo: CGFloat {
        isOver ? 0.99 : trimPercentValue
    }

    private var trimFrom: CGFloat {
        isOver ? 0.01 : 0.0
    }

    private var rotationAngle: CGFloat {
        let defaultAngle: CGFloat = -90
        guard isOver else {
            return defaultAngle
        }
        let percent = trimPercentValue - CGFloat(Int(trimPercentValue))
        return percent * 360 - 90
    }

    func setTrimValue(isCurrentTab: Bool) {
        trimPercentValue = isCurrentTab ? trimPercent : 0
    }
}


private extension CGFloat {
    static let totalSize: CGFloat = 140
    static let circleSize: CGFloat = 132
    static let circleBorderWidth: CGFloat = 6
}

#Preview {
    CaloriesBudgetHeaderRingView(calories: 1666, title: "title", trimPercent: 2.1)
        .background(.red)
}