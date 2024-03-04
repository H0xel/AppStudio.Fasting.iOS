//
//  PersonalizedBulletPointsView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedBulletPointsView: View {
    let viewData: [String]

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(viewData, id: \.self) { data in
                HStack(spacing: .zero) {
                    Image.checkmarkCircleFill
                        .font(.subheadline)
                        .foregroundStyle(Color.studioBlue)
                        .padding(.trailing, Layout.trailingPadding)
                    Text(data)
                        .font(.poppins(.body))
                    Spacer()
                }
                .padding(.bottom, Layout.bottomPadding)
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

private extension PersonalizedBulletPointsView {
    enum Layout {
        static let horizontalPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 12
        static let trailingPadding: CGFloat = 16
    }
}

#Preview {
    PersonalizedBulletPointsView(viewData: [
        "Lose ~3 kg by your birthday!",
        "Start seeing results in just 1 month",
        "Build your dream body",
        "Become more active in daily life"
    ])
}
