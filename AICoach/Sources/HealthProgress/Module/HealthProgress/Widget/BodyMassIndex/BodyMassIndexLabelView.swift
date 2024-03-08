//
//  BodyMassIndexLabelView.swift
//
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI

struct BodyMassIndexLabelView: View {

    let index: Double

    var body: some View {
        HStack(alignment: .bottom) {
            Text(String(format: "%.2f", index))
                .font(.poppins(.headerM))
                .foregroundStyle(Color.studioBlackLight)
            Text("\(.kgForSquareMetter)\u{00B2}")
                .font(.poppins(.description))
                .foregroundStyle(Color.studioBlackLight)
                .offset(y: .yOffset)
            Spacer()
            Text(index.bodyMassIndex.title)
                .foregroundStyle(.white)
                .font(.poppins(.description))
                .padding(.horizontal, .labelHorizontalPadding)
                .padding(.vertical, .labelVerticalPadding)
                .background(index.bodyMassIndex.color)
                .continiousCornerRadius(.labelCornerRadius)
                .offset(y: .yOffset)
        }
    }
}

private extension String {
    static let kgForSquareMetter = "BodyMassIndexView.kgForSquareMetter".localized(bundle: .module)
}

private extension CGFloat {
    static let labelHorizontalPadding: CGFloat = 8
    static let labelVerticalPadding: CGFloat = 4
    static let labelCornerRadius: CGFloat = 32
    static let yOffset: CGFloat = -2.5
}

#Preview {
    BodyMassIndexLabelView(index: 22.3)
}
