//
//  ArticleView.swift
//
//
//  Created by Руслан Сафаргалеев on 19.04.2024.
//

import SwiftUI
import AppStudioUI

enum ArticlePreviewSize {
    case small
    case large
    case custom(width: CGFloat, height: CGFloat, imageHeight: CGFloat)

    var viewSize: CGSize {
        switch self {
        case .small: .init(width: 160, height: 283)
        case .large: .init(width: 328, height: 339)
        case let .custom(width, height, _): .init(width: width, height: height)
        }
    }

    var imageHeight: CGFloat {
        switch self {
        case .small: 160
        case .large: 240
        case .custom(_, _, let imageHeight): imageHeight
        }
    }

    var lineLimit: Int {
        switch self {
        case .small, .custom: 3
        case .large: 2
        }
    }
}


struct ArticlePreviewView: View {

    @StateObject var viewModel: ArticlePreviewViewModel
    let style: ArticlePreviewSize
    let onTap: (Article, Image?) -> Void

    var body: some View {
        Button(action: {
            onTap(viewModel.article, viewModel.image)
        }, label: {
            VStack(spacing: .imageBottomPadding) {
                if let image = viewModel.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()

                        .frame(height: style.imageHeight)
                        .frame(maxWidth: style.viewSize.width)
                } else {
                    ArticleImagePlaceholderView(backgroundColor: placeholderBackgroundColor,
                                                height: style.imageHeight,
                                                width: style.viewSize.width)
                    .aspectRatio(contentMode: .fill)
                }
                VStack(alignment: .leading, spacing: .zero) {
                    Text(viewModel.article.title)
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioBlackLight)
                        .lineLimit(style.lineLimit)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: .titleBottomSpacing)
                    Text("\(viewModel.article.readTime ?? 0) \(String.timeToRead)")
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGreyText)
                        .aligned(.left)
                }
                .padding(.horizontal, .horizontalPadding)
                .padding(.bottom, .bottomPadding)
            }
            .frame(height: style.viewSize.height)
            .frame(maxWidth: style.viewSize.width)
            .background(.white)
            .continiousCornerRadius(.cornerRadius)
        })
    }

    private var placeholderBackgroundColor: Color {
        [Color.studioSky,
         .studioRed,
         .studioGreen,
         .studioPurple,
         .studioOrange].randomElement() ?? .studioRed
    }
}

private extension String {
    static let timeToRead = "ArticlePreviewView.timeToRead".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let imageBottomPadding: CGFloat = 12
    static let bottomPadding: CGFloat = 16
    static let titleBottomSpacing: CGFloat = 8
    static let cornerRadius: CGFloat = 20
}

#Preview {
    ZStack {
        Color.red
        ScrollView {
            VStack {
                ArticlePreviewView(viewModel: .init(article: .mock),
                                   style: .custom(width: 300, height: 300, imageHeight: 200), onTap: { _, _ in })
                ArticlePreviewView(viewModel: .init(article: .mock),
                                   style: .small, onTap: { _, _ in })
                ArticlePreviewView(viewModel: .init(article: .mock),
                                   style: .large, onTap: { _, _ in })
            }
        }
    }
}
