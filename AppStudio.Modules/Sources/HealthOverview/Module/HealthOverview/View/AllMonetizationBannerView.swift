//
//  AllMonetizationBannerView.swift
//
//
//  Created by Amakhin Ivan on 10.04.2024.
//

import SwiftUI
import AppStudioStyles

struct AllMonetizationBannerView: View {
    var action: () -> Void

    var body: some View {
        HStack(spacing: .zero) {
            Text("MonetizationBanner.enjoyFasting".localized(bundle: .module))
                .font(.poppinsBold(.buttonText))
                .foregroundStyle(.white)
            Spacer()
            Text("MonetizationBanner.getPlus".localized(bundle: .module))
                .font(.poppins(.description))
                .foregroundStyle(.white)
                .padding(.horizontal, .plustHorizontalPadding)
                .padding(.vertical, .plustVerticalPadding)
                .background(Color.studioBlackLight)
                .continiousCornerRadius(.plustCornerRadius)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.vertical, .verticalPadding)
        .background(
            LinearGradient(
                colors: [
                    .studioOrange,
                    .studioRed,
                    .studioPurple,
                    .studioBlue,
                    .studioSky
                ],
                startPoint: .trailing,
                endPoint: .leading
            )
        )
        .continiousCornerRadius(.cornerRadius)
        .onTapGesture {
            action()
        }
    }
}

private extension CGFloat {
    static let plustHorizontalPadding: CGFloat = 20
    static let plustVerticalPadding: CGFloat = 14.5
    static let plustCornerRadius: CGFloat = 44
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
}

#Preview {
    AllMonetizationBannerView() {}
}
