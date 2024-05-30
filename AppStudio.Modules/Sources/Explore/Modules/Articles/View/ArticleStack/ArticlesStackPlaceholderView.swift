//
//  ArticlesStackPlaceholderView.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import SwiftUI

struct ArticlesStackPlaceholderView: View {

    let size: ArticleStackSize

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach(colors, id: \.self) { color in
                ArticlePlaceholderView(backgroundColor: color, size: size)
            }
        }
    }

    private var colors: [Color] {
        switch size {
        case .small: [.studioSky, .studioRed, .studioGreen]
        case .large: [.studioOrange, .studioPurple]
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
}

#Preview {
    ArticlesStackPlaceholderView(size: .small)
}
