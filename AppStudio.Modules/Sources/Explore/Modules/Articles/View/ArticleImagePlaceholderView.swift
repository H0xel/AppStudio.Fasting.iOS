//
//  ArticleImagePlaceholderView.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import SwiftUI

struct ArticleImagePlaceholderView: View {

    let backgroundColor: Color
    let height: CGFloat
    let width: CGFloat?

    var body: some View {
        backgroundColor
            .frame(width: width, height: height)
            .frame(maxWidth: width ?? .infinity)
            .overlay(
                Image.photoFill
                    .font(.title2)
                    .foregroundStyle(.white)
                    .opacity(0.6)
            )
    }
}

#Preview {
    ArticleImagePlaceholderView(backgroundColor: .studioRed,
                                height: 160,
                                width: 160)
}
