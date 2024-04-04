//
//  WeightProgressDatesView.swift
//
//
//  Created by Руслан Сафаргалеев on 28.03.2024.
//

import SwiftUI

enum WeightProgressWeightOutput {
    case prevTap
    case nextTap
    case titleTap
}

struct WeightProgressDatesView: View {

    let startDate: Date
    let endDate: Date
    let minDate: Date
    let output: (WeightProgressWeightOutput) -> Void

    var body: some View {
        HStack(spacing: .spacing) {
            // TODO: - Раскомментировать когда придет время
//            Button(action: {
//                output(.prevTap)
//            }) {
//                Image.chevronLeft
//            }
//            .foregroundStyle(
//                startDate > minDate ?
//                        Color.studioBlackLight :
//                        .studioGreyPlaceholder
//            )
            Button(action: {
                output(.titleTap)
            }) {
                Text(dates)
                    .font(.poppinsMedium(.body))
                    .frame(width: .datesWidth)
            }
            // TODO: - Раскомментировать когда придет время
//            Button(action: {
//                output(.nextTap)
//            }) {
//                Image.chevronRight
//            }
//            .foregroundStyle(
//                endDate < .now.beginningOfDay ?
//                        Color.studioBlackLight :
//                        .studioGreyPlaceholder
//            )
        }
        .foregroundStyle(Color.studioBlackLight)
    }

    private var dates: String {
        let start = startDate.currentLocaleFormatted(with: "MMMdd")
        let end = endDate.currentLocaleFormatted(with: "MMMdd")
        return "\(start) - \(end)"
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let datesWidth: CGFloat = 140
}

#Preview {
    WeightProgressDatesView(startDate: .now.add(days: -6),
                            endDate: .now, 
                            minDate: .now.add(days: -6),
                            output: { _ in })
}
