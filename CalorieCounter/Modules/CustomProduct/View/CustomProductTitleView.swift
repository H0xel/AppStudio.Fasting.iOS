//
//  CustomProductTitleView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI

struct CustomProductTitleView: View {

    let productName: String
    let brandName: String?

    var body: some View {
        VStack(spacing: .spacing) {
            Text(productName)
                .font(.poppins(.headerM))
            if let brandName, !brandName.trim.isEmpty {
                Text(brandName)
                    .font(.poppins(.buttonText))
            }
        }
        .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
}

#Preview {
    CustomProductTitleView(productName: "Cheese Brie",
                           brandName: "President")
}
