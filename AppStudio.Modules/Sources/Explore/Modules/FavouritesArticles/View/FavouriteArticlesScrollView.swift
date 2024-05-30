//
//  FavouriteArticlesScrollView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI
import MunicornUtilities

struct FavouriteArticlesScrollView: View {

    let articles: [Article]
    let onTap: (Article, Image?) -> Void

    var body: some View {
        ScrollView(.vertical) {
            Spacer(minLength: .verticalSpacing)
            LazyVGrid(columns: [GridItem(.fixed(cellWidth)),
                                GridItem(.fixed(cellWidth))],
                      spacing: .spacing) {
                ForEach(articles) { article in

                    ArticlePreviewView(
                        viewModel: .init(article: article),
                        style: .custom(width: cellWidth,
                                       height: .cellHeight,
                                       imageHeight: .cellImageHeight),
                        onTap: { article, image in
                            onTap(article, image)
                        })
                }
            }
            .padding(.horizontal, .horizontalPadding)
            Spacer(minLength: .verticalSpacing)
        }
        .scrollIndicators(.hidden)
        .background(Color.studioGrayFillProgress)
    }
    private var cellWidth: CGFloat {
        (screenWidth - 40) / 2
    }
}


private extension CGFloat {
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 16
    static let cellHeight: CGFloat = 283
    static let cellImageHeight: CGFloat = 160

}

#Preview {
    FavouriteArticlesScrollView(articles: [.mock, .mock, .mock, .mock, .mock], onTap: { _, _ in })
}
