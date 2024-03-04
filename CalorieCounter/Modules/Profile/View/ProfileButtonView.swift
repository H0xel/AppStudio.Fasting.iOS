//
//  ProfileButtonView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import SwiftUI
import AppStudioUI

struct ProfileButtonView: View {

    let title: LocalizedStringKey
    var description: String?
    var image: Image?
    let roundedCorners: UIRectCorner
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: .zero) {
                if let image {
                    image
                        .padding(.trailing, Layout.imageTrailingPadding)
                }
                Text(title)
                    .foregroundStyle(.accent)
                Spacer()
                if let description {
                    Text(description)
                        .foregroundStyle(Color.studioGreyText)
                        .padding(.trailing, Layout.descriptionTrailingPadding)
                }
                Image.chevronRight
                    .foregroundStyle(Color.studioGreyStrokeFill)
            }
            .font(.poppins(.body))
            .padding(.trailing, Layout.trailingPadding)
            .padding(.leading, Layout.leadingPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(.white)
            .corners(roundedCorners, with: Layout.cornerRadius)
        }
    }
}

private extension ProfileButtonView {
    enum Layout {
        static let leadingPadding: CGFloat = 20
        static let trailingPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 20
        static let imageTrailingPadding: CGFloat = 16
        static let descriptionTrailingPadding: CGFloat = 14
    }
}
