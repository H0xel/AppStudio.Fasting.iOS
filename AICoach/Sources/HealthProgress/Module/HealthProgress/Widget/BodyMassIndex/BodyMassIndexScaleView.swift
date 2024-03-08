//
//  BodyMassIndexScaleView.swift
//
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI

struct BodyMassIndexScaleView: View {

    let index: Double

    @State private var viewWidth: CGFloat = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: .zero) {
            ForEach(BodyMassIndex.allCases, id: \.self) { index in
                VStack(alignment: .leading, spacing: .zero) {
                    if isInRange(index: index) {
                        Image(.bmiIndex)
                            .padding(.bottom, .indexBottomPadding)
                            .offset(x: .indexLeadingPadding)
                            .offset(x: leadingPadding(index: index))
                    }
                    index.color
                        .frame(height: .height)
                        .corners(
                            [.topLeft, .bottomLeft],
                            with: index == BodyMassIndex.allCases.first ? .cornerRadius : 0
                        )
                        .corners(
                            [.topRight, .bottomRight],
                            with: index == BodyMassIndex.allCases.last ? .cornerRadius : 0
                        )
                    HStack {
                        numberView(for: index.minValue)
                        if index == BodyMassIndex.allCases.last {
                            Spacer()
                            numberView(for: index.maxValue)
                        }
                    }
                }
                .frame(width: width(for: index))
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.bouncy, value: self.index)
        .withViewWidthPreferenceKey
        .onViewWidthPreferenceKeyChange { newWidth in
            viewWidth = newWidth
        }
    }

    private func numberView(for value: Double) -> some View {
        Text("\(Int(value))")
            .font(.poppins(.description))
            .foregroundStyle(Color.studioGreyText)
            .padding(.top, .textTopPadding)
    }

    private func width(for index: BodyMassIndex) -> CGFloat {
        viewWidth / 50 * (index.maxValue - index.minValue)
    }

    private func isInRange(index: BodyMassIndex) -> Bool {
        (index.minValue ..< index.maxValue).contains(normalizedIndex)
    }

    private func leadingPadding(index: BodyMassIndex) -> CGFloat {
        let indexWidth = width(for: index)
        let leftInset = normalizedIndex - index.minValue
        let indexLength = index.maxValue - index.minValue
        return (indexWidth / indexLength) * leftInset
    }

    private var normalizedIndex: Double {
        min(59.9, max(10, self.index))
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 17
    static let height: CGFloat = 12
    static let textTopPadding: CGFloat = 9
    static let indexBottomPadding: CGFloat = 2
    static let indexLeadingPadding: CGFloat = -6.2
}

#Preview {
    BodyMassIndexScaleView(index: 23)
        .padding(36)
}
