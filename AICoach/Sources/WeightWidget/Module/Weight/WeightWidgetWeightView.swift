//
//  WeightWidgetWeightView.swift
//
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioModels

struct WeightWidgetWeightView: View {

    let title: String
    let weight: WeightMeasure?
    let isBig: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: .verticalSpacing) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
            HStack(alignment: .bottom, spacing: .weightSpacing) {
                Text(value)
                    .font(.poppins(isBig ? .headerM : .description))
                Text(units)
                    .font(.poppins(.description))
                    .offset(y: isBig ? .weightUnitOffset : .zero)
                    .padding(.top, isBig ? 0 : .trueWeightTopPadding)
            }
            .foregroundStyle(Color.studioBlackLight)
        }
    }

    private var units: String {
        weight?.units.title ?? ""
    }

    private var value: String {
        if let value = weight?.value {
            return String(format: "%.1f", value)
        }
        return "--"
    }
}

private extension CGFloat {
    static let verticalSpacing: CGFloat = 4
    static let weightSpacing: CGFloat = 4
    static let trueWeightTopPadding: CGFloat = 4
    static let weightUnitOffset: CGFloat = -2
}

#Preview {
    WeightWidgetWeightView(title: "Scale Weight",
                           weight: .init(value: 56.6),
                           isBig: true)
}
