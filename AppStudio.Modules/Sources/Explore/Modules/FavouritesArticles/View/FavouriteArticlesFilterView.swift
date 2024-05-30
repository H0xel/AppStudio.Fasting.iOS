//
//  FavouriteArticlesFilterView.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI

struct FavouriteArticlesFilterView: View {

    @Binding var type: ArticleType

    var body: some View {
        HStack(spacing: .spacing) {
            ForEach([ArticleType.recipe, .article], id: \.self) { type in
                Button(action: {
                    self.type = type
                }, label: {
                    Text(title(type: type))
                        .foregroundStyle(Color.studioBlackLight)
                        .font(type == self.type ? .poppinsMedium(.description) : .poppins(.description))
                        .padding(.horizontal, .chipHorizontalPadding)
                        .padding(.vertical, .chipVerticalPadding)
                        .background {
                            if type == self.type {
                                Color.studioGrayFillProgress
                                    .continiousCornerRadius(.cornerRadius)
                            }
                        }
                        .border(configuration: .init(
                            cornerRadius: .cornerRadius,
                            color: .studioGreyStrokeFill,
                            lineWidth: type == self.type ? 0 : .borderWidth
                        ))
                })
            }
        }
        .padding(.vertical, .verticalPadding)
        .aligned(.centerHorizontaly)
        .background(.white)
    }

    private func title(type: ArticleType) -> String {
        switch type {
        case .article: .articles
        case .recipe: .recipes
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let chipHorizontalPadding: CGFloat = 20
    static let chipVerticalPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 32
    static let borderWidth: CGFloat = 0.5
    static let verticalPadding: CGFloat = 16
}

private extension String {
    static let articles = "FavouriteArticlesScreen.articles".localized(bundle: .module)
    static let recipes = "FavouriteArticlesScreen.recipes".localized(bundle: .module)
}

#Preview {
    ZStack {
        Color.red
        FavouriteArticlesFilterView(type: .constant(.recipe))
    }
}
