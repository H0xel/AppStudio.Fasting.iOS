//
//  FastingPhaseArticleParagraphView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.12.2023.
//

import SwiftUI

struct FastingPhaseArticleParagraphView: View {

    let paragraphs: [Paragraph]
    let pointColor: Color

    var body: some View {
        VStack(spacing: .zero) {
            ForEach(paragraphs, id: \.self) { paragraph in
                HStack(alignment: .top, spacing: .zero) {
                    Image.diamondFill
                        .foregroundStyle(pointColor)
                        .font(.system(size: 8))
                        .aligned(.left)
                        .frame(width: Layout.pointWidth, height: Layout.pointHeight)
                    Text(paragraph.text)
                        .font(.poppins(.body))
                        .foregroundStyle(.accent)
                }
                .aligned(.left)
                .padding(.bottom, Layout.bottomPadding)

                FastingPhaseArticleParagraphView(paragraphs: paragraph.paragraphs, pointColor: pointColor)
                    .padding(.leading, 32)
            }
        }
    }
}

private extension FastingPhaseArticleParagraphView {
    enum Layout {
        static let bottomPadding: CGFloat = 20
        static let pointHeight: CGFloat = 24
        static let pointWidth: CGFloat = 32
    }
}

#Preview {
    var points = (1...7).map {
        Paragraph(text: NSLocalizedString("FastingPhaseArticle.sugarRises.point\($0)", comment: ""),
                  paragraphs: [])
    }
    return FastingPhaseArticleParagraphView(paragraphs: points,
                                 pointColor: .blue)
}
