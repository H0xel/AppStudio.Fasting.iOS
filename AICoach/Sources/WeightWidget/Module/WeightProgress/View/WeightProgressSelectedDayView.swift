//
//  WeightProgressSelectedDayView.swift
//
//
//  Created by Руслан Сафаргалеев on 29.03.2024.
//

import SwiftUI
import AppStudioStyles
import AppStudioModels

struct WeightProgressSelectedDayView: View {

    let selectedDate: Date
    let scaleWeight: WeightMeasure?
    let trueWeight: WeightMeasure?
    let onClose: () -> Void
    @State private var feedbackGenerator: UIImpactFeedbackGenerator?

    var body: some View {
        VStack(spacing: .spacing) {
            Text(selectedDate.startOfTheDay.currentLocaleFormatted(with: "MMMMdd"))
                .font(.poppinsMedium(.body))
                .foregroundStyle(Color.studioBlackLight)
                .frame(maxWidth: .infinity)
                .background(
                    Button(action: onClose) {
                        Image.close
                            .foregroundStyle(Color.studioGreyText)
                            .aligned(.right)
                            .padding(.trailing, .trailingPadding)
                    }
                )
            HStack {
                Spacer()
                WeightValueView(title: .trueWeight,
                                weight: trueWeight,
                                isBig: true,
                                alignment: .center)
                Spacer()
                WeightValueView(title: .scaleWeight,
                                weight: scaleWeight,
                                isBig: true,
                                alignment: .center)
                Spacer()
            }
        }
        .padding(.vertical, .verticalPadding)
        .background(Color.studioGreyFillCard)
        .continiousCornerRadius(.cornerRadius)
        .onAppear {
            feedbackGenerator = .init(style: .soft)
            feedbackGenerator?.impactOccurred()
            feedbackGenerator = nil
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 12
    static let trailingPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 20
    static let verticalPadding: CGFloat = 16
}

private extension String {
    static let scaleWeight = "WeightWidgetView.scaleWeight".localized(bundle: .module)
    static let trueWeight = "WeightWidgetView.trueWeight".localized(bundle: .module)
}

#Preview {
    WeightProgressSelectedDayView(selectedDate: .now,
                                  scaleWeight: .init(value: 56),
                                  trueWeight: .init(value: 57.6), 
                                  onClose: {})
    .padding(.horizontal, 16)
}
