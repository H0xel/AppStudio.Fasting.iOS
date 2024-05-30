//
//  MealDeleteBannerButton.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import SwiftUI

struct MealDeleteBannerButton: View {
    let image: Image
    let title: String

    var body: some View {
        VStack(spacing: .spacing) {
            image
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageSize, height: .imageSize)

            Text(title)
                .font(.poppins(.fontSize))
        }
        .foregroundStyle(Color.studioBlackLight)
    }
}
private extension CGFloat {
    static let imageSize: CGFloat = 24
    static let spacing: CGFloat = 8
    static let fontSize: CGFloat = 11
}
