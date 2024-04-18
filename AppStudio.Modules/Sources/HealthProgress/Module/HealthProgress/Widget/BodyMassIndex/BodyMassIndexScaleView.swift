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
        VStack(spacing: .zero) {
            Image(.bmiIndex)
                .padding(.bottom, .indexBottomPadding)
                .aligned(.left)
                .offset(x: .indexLeadingPadding)
                .offset(x: arrowOffset)

            HStack(alignment: .bottom, spacing: .zero) {
                ForEach(BodyMassIndex.allCases, id: \.self) { index in
                    VStack(alignment: .leading, spacing: .zero) {
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
        }
        .frame(maxWidth: .infinity)
        .animation(.bouncy, value: index)
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

    private var arrowOffset: CGFloat {
        viewWidth / 50 * (normalizedIndex - 10)
    }

    private var normalizedIndex: Double {
        min(59.9, max(10, index))
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
