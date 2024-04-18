//
//  ScaleWeightHistoryWeightView.swift
//
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import SwiftUI

struct ScaleWeightHistoryWeightView: View {

    let weight: ScaleWeight

    var body: some View {
        HStack(spacing: .zero) {
            arrowView
                .frame(width: .arrowWidth, height: .arrowWidth)
                .padding(.trailing, .arrowTrailingPadding)
            VStack(alignment: .leading, spacing: .verticalSpacing) {
                Text(weight.weight.valueWithSingleDecimalInNeeded)
                    .font(.poppins(.body))
                    .foregroundStyle(Color.studioBlackLight)
                if let change = weight.changeOverPrevDay {
                    Text(change.valueWithSingleDecimalInNeeded)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGreyText)
                }
            }
            Spacer()
            Text(weight.date.currentLocaleFormatted(with: "MMMdd"))
                .font(.poppins(.body))
                .foregroundStyle(Color.studioGreyText)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .verticalPadding)
        .background(Color.studioGreyFillCard)
    }

    @ViewBuilder
    private var arrowView: some View {
        if let change = weight.changeOverPrevDay {
            if change.value > 0 {
                Image.arrowUp
                    .foregroundStyle(Color.studioRed)
            } else if change.value < 0 {
                Image.arrowDown
                    .foregroundStyle(Color.studioGreen)
            } else {
                Color.studioGreyFillCard
            }
        } else {
            Color.studioGreyFillCard
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let arrowTrailingPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 4
    static let arrowWidth: CGFloat = 24
}

#Preview {
    VStack(spacing: 4) {
        ScaleWeightHistoryWeightView(
            weight: .init(
                id: "",
                weight: .init(value: 56.6),
                changeOverPrevDay: .init(value: -0.4),
                date: .now
            )
        )
        ScaleWeightHistoryWeightView(
            weight: .init(
                id: "",
                weight: .init(value: 57.6),
                changeOverPrevDay: .init(value: 0.7),
                date: .now.add(days: -1)
            )
        )
        ScaleWeightHistoryWeightView(
            weight: .init(
                id: "",
                weight: .init(value: 56.6),
                changeOverPrevDay: nil,
                date: .now.add(days: -2)
            )
        )
    }
}
