//
//  ProfileButtonView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 02.11.2023.
//

import SwiftUI
import AppStudioUI

struct ProfileButtonView: View {

    let title: LocalizedStringKey
    let image: Image?
    let roundedCorners: UIRectCorner
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Layout.spacing) {
                if let image {
                    image
                }
                Text(title)
                    .foregroundStyle(.accent)
                Spacer()
                Image.chevronRight
                    .foregroundStyle(Color.studioGreyStrokeFill)
            }
            .font(.poppins(.buttonText))
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(Color.studioGrayFillCard)
            .corners(roundedCorners, with: Layout.cornerRadius)
        }
    }
}

private extension ProfileButtonView {
    enum Layout {
        static let spacing: CGFloat = 16
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
    }
}
