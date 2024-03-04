//
//  PersonalizedStartWeightView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedStartWeightView: View {
    let startWeight: String

    var body: some View {
        Text(startWeight)
            .font(.poppins(.headerS))
            .padding(.top, Layout.startWeightTopPadding)
            .padding(.leading, Layout.startWeightLeadingPadding)
            .aligned(.topLeft)
    }
}

extension PersonalizedStartWeightView {
    enum Layout {
        static let startWeightTopPadding: CGFloat = 24
        static let startWeightLeadingPadding: CGFloat = 24
    }
}

#Preview {
    PersonalizedStartWeightView(startWeight: "56 kg")
}
