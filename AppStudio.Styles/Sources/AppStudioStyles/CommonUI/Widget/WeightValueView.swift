//
//  WeightValueView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import SwiftUI
import AppStudioModels

public struct WeightValueView: View {

    private let title: String
    private let weight: WeightMeasure?
    private let isBig: Bool
    private let colorForNegativeNumbers: Color?
    private let alignment: HorizontalAlignment
    private let usePlusSign: Bool

    public init(title: String,
                weight: WeightMeasure?,
                isBig: Bool,
                alignment: HorizontalAlignment = .leading,
                usePlusSign: Bool = false,
                colorForNegativeNumbers: Color? = nil) {
        self.title = title
        self.weight = weight
        self.isBig = isBig
        self.colorForNegativeNumbers = colorForNegativeNumbers
        self.alignment = alignment
        self.usePlusSign = usePlusSign
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: .verticalSpacing) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
            HStack(alignment: .bottom, spacing: .weightSpacing) {
                Text(value)
                    .font(.poppins(isBig ? .headerM : .description))
                    .foregroundStyle(valueColor)
                Text(units)
                    .font(.poppins(.description))
                    .offset(y: isBig ? .weightUnitOffset : .zero)
                    .padding(.top, isBig ? 0 : .trueWeightTopPadding)
                    .foregroundStyle(Color.studioBlackLight)
            }
        }
    }

    private var valueColor: Color {
        if let colorForNegativeNumbers,
           let value = weight?.value,
           value < 0 {
            return colorForNegativeNumbers
        }
        return .studioBlackLight
    }

    private var units: String {
        weight?.units.title ?? ""
    }

    private var value: String {
        if let value = weight?.value {
            let sign = value > 0 && usePlusSign ? "+" : ""
            return "\(sign)\(String(format: "%.1f", value))"
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
    WeightValueView(title: "Scale Weight",
                    weight: .init(value: 56.6),
                    isBig: true)
}
