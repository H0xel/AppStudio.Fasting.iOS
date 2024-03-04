//
//  PaywallFeaturesView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI

struct PaywallFeaturesView: View {

    let features: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            ForEach(features, id: \.self) { feature in
                HStack(spacing: .horizontalSpacing) {
                    Image.plus
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: .plusWidth, height: .plusWidth)
                        .background(Color.studioGreen)
                        .continiousCornerRadius(.plusWidth / 2)
                    Text(feature)
                        .foregroundStyle(.accent)
                        .font(.poppins(.buttonText))
                }
            }
        }
        .aligned(.left)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 21
    static let horizontalSpacing: CGFloat = 16
    static let plusWidth: CGFloat = 24
}

#Preview {
    PaywallFeaturesView(features: [
        "AI-powered Food Log",
        "Barcode Scan",
        "Complete Macro Tracking"
    ])
}
