//
//  WeightProgressChipsView.swift
//
//
//  Created by Руслан Сафаргалеев on 28.03.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioUI

struct WeightProgressChipsView: View {

    @Binding var selectedScale: DateChartScale
    let scales: [DateChartScale]

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach(scales, id: \.self) { scale in
                Button(action: {
                    selectedScale = scale
                }, label: {
                    Text(scale.title)
                        .font(scale == selectedScale ?
                            .poppinsMedium(.description) :
                                .poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(.vertical, .verticalPadding)
                        .padding(.horizontal, .horizontalPadding)
                        .background(scale == selectedScale ? Color.studioGreyFillProgress : .white)
                        .continiousCornerRadius(.cornerRadius)
                        .border(configuration: .init(
                            cornerRadius: .cornerRadius,
                            color: .studioGreyStrokeFill,
                            lineWidth: scale == selectedScale ? .zero : .borderWidth)
                        )
                })
            }
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let verticalPadding: CGFloat = 10
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 32
    static let borderWidth: CGFloat = 0.5
}

#Preview {
    WeightProgressChipsView(selectedScale: .constant(.week),
                            scales: DateChartScale.allCases)
}
