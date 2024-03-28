//
//  WeightGoalProgressView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioModels

struct WeightGoalProgressView: View {

    let startWeight: WeightMeasure
    let goalWeight: WeightMeasure
    let currentWeight: WeightMeasure

    @State private var viewWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: .spacing) {
            ZStack(alignment: .leading) {
                Color.studioGreyFillProgress
                    .continiousCornerRadius(.barHeight)
                    .withViewWidthPreferenceKey
                Color.green
                    .frame(width: progressWidth)
                    .continiousCornerRadius(.barHeight)
            }
            .frame(height: .barHeight)

            HStack {
                Text("\(String.start): \(startWeight.valueWithSingleDecimalInNeeded)")
                Spacer()
                Text("\(String.goal): \(goalWeight.valueWithSingleDecimalInNeeded)")
            }
            .font(.poppins(.description))
            .foregroundStyle(Color.studioGreyText)
        }
        .onViewWidthPreferenceKeyChange { newWidth in
            viewWidth = newWidth
        }
    }

    private var progressWidth: CGFloat {
        let goal = goalWeight.normalizeValue
        let start = startWeight.normalizeValue
        let current = currentWeight.normalizeValue
        let startToGoalDifference = start - goal
        let progress = start - current
        let percent = min(1, progress / startToGoalDifference)
        return max(0, percent * viewWidth)
    }
}

private extension String {
    static let start = "WeightGoalProgressView.start".localized(bundle: .module)
    static let goal = "WeightGoalProgressView.goal".localized(bundle: .module)
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let barHeight: CGFloat = 12
}

#Preview {
    ZStack {
        Color.studioGreyStrokeFill
        WeightGoalProgressView(startWeight: .init(value: 56.65),
                               goalWeight: .init(value: 52),
                               currentWeight: .init(value: 52.4))
        .padding(36)
    }
}
