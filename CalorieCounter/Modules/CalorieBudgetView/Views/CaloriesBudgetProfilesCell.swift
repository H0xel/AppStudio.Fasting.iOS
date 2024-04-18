//
//  CaloriesBudgetProfilesCell.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.01.2024.
//

import SwiftUI

struct CaloriesBudgetProfilesCell: View {
    let type: NutritionType
    let value: Double
    let total: Double
    @State private var barTotalWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: .verticalSpacing) {
            HStack(alignment: .center, spacing: .horizontalSpacing) {
                Text(type.firstLetter)
                    .font(.poppinsBold(.body))
                    .foregroundStyle(type.color)
                HStack(spacing: 0) {
                    Text(value.formattedCaloriesString)
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioBlackLight)

                    Text("/\(total.formattedCaloriesString)")
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioGrayPlaceholder)
                }
            }
            .animation(nil, value: value)

            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                RoundedRectangle(cornerRadius: .barTotalHeight)
                    .stroke(Color.studioGrayFillProgress, lineWidth: .barTotalHeight)

                RoundedRectangle(cornerRadius: .barTotalHeight)
                    .stroke(type.color, lineWidth: .barTotalHeight)
                    .frame(width: barWidth)
            }
            .frame(height: .barTotalHeight)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            setTotalWidth(proxy.size.width, isCurrentTab: true)
                        }
                        .onDisappear {
                            setTotalWidth(proxy.size.width, isCurrentTab: false)
                        }
                }
            )
            .animation(.linear, value: barTotalWidth)
        }
    }

    private var barWidth: CGFloat {
        progress * barTotalWidth
    }

    private var progress: CGFloat {
        let progress = total == 0 ? 0 : (value / total)
        return progress > 1.0 ? 1.0 : progress
    }

    private func setTotalWidth(_ width: CGFloat, isCurrentTab: Bool) {
        barTotalWidth = isCurrentTab ? width : 0
    }
}

private extension CGFloat {
    static let barTotalHeight: CGFloat = 2
    static let verticalSpacing: CGFloat = 10
    static let horizontalSpacing: CGFloat = 10
}

#Preview {
    CaloriesBudgetProfilesCell(type: .carbs, value: 1000, total: 1200)
}
