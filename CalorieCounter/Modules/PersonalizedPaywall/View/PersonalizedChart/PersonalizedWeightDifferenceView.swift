//
//  PersonalizedWeightDifferenceView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedWeightDifferenceView: View {
    let weightDifference: String
    let endWeight: String

    var body: some View {
        VStack(alignment: .trailing, spacing: Layout.weightDifferenceSpacing) {
            Text(weightDifference)
                .foregroundStyle(Color.studioRed)
            Text(endWeight)
        }
        .font(.poppins(.headerS))
        .padding(.trailing, Layout.weightDifferenceTrailingPadding)
        .padding(.bottom, Layout.weightDifferenceBottomPadding)
        .aligned(.bottomRight)
    }
}

private extension PersonalizedWeightDifferenceView {
    enum Layout {
        static let weightDifferenceBottomPadding: CGFloat = 67
        static let weightDifferenceTrailingPadding: CGFloat = 24
        static let weightDifferenceSpacing: CGFloat = 4
    }
}

#Preview {
    PersonalizedWeightDifferenceView(weightDifference: "- 4 kg", endWeight: "53 kg")
}
