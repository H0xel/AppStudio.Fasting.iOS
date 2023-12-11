//
//  FastingPhaseArticleView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.12.2023.
//

import SwiftUI

struct FastingPhaseArticleView: View {

    let article: Article
    let pointColor: Color

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(article.paragraphs, id: \.self) { paragraph in
                Text(paragraph.text)
                    .font(.poppins(.buttonText))
                    .padding(.bottom, Layout.paragraphBottomPadding)
                FastingPhaseArticleParagraphView(paragraphs: paragraph.paragraphs, pointColor: pointColor)
            }
        }
        .foregroundStyle(.accent)
    }
}

private extension FastingPhaseArticleView {
    enum Layout {
        static let pointBottomPadding: CGFloat = 20
        static let paragraphBottomPadding: CGFloat = 28
    }
}

#Preview {
    ScrollView {
        FastingPhaseArticleView(article: .burning, pointColor: .blue)
    }
}
