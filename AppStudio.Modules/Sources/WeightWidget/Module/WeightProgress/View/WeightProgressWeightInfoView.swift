//
//  WeightProgressWeightInfoView.swift
//  
//
//  Created by Руслан Сафаргалеев on 29.03.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioStyles

struct WeightProgressWeightInfoView: View {

    let weight: WeightMeasure
    let weightChange: WeightMeasure

    var body: some View {
        HStack {
            Spacer()
            WeightValueView(title: .averageWeight,
                            weight: weight,
                            isBig: true,
                            alignment: .center)
            Spacer()
            WeightValueView(title: .chageOverPeriod,
                            weight: weightChange,
                            isBig: true,
                            alignment: .center,
                            usePlusSign: true,
                            colorForNegativeNumbers: .studioGreen)
            Spacer()
        }
    }

    private func titleView(text: String) -> some View {
        Text(text)
            .font(.poppins(.description))
            .foregroundStyle(Color.studioGreyText)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
}

private extension String {
    static let averageWeight = "WeightProgressScreen.averageTrueWeight".localized(bundle: .module)
    static let chageOverPeriod = "WeightProgressScreen.chageOverPeriod".localized(bundle: .module)
}

#Preview {
    WeightProgressWeightInfoView(weight: .init(value: 57.6),
                                 weightChange: .init(value: 1.2))
}
