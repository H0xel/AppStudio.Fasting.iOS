//
//  InActiveFastingListView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import SwiftUI

struct InActiveFastingListView: View {
    let viewData: ViewData

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .zero) {

            switch viewData.type {
            case .number(let int):
                Text("\(int).")
                    .foregroundStyle(Color.studioSky)
                    .font(.poppins(.body))
                    .padding(.vertical, Layout.verticalImagePadding)
                    .padding(.trailing, Layout.imageTrailingPadding)
                    .fixedSize()
                    .aligned(.topLeft)
            case .bullet:
                Image.diamondFill
                    .foregroundStyle(Color.studioSky)
                    .font(.system(size: Layout.imageSize))
                    .padding(.vertical, Layout.verticalImagePadding)
                    .padding(.trailing, Layout.imageTrailingPadding)
                    .aligned(.topLeft)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(viewData.title)
                    .font(.poppins500(.body))

                Text(viewData.subtitle)
                    .padding(.bottom, Layout.textBottomPadding)
                    .multilineTextAlignment(.leading)
                    .font(.poppins(.body))
                    .lineSpacing(Layout.lineSpacing)
                    .aligned(.left)
            }
            .layoutPriority(1)
        }
    }
}

extension InActiveFastingListView {
    struct ViewData {
        let type: BulletType
        let title: LocalizedStringKey
        let subtitle: LocalizedStringKey

        enum BulletType {
            case number(Int)
            case bullet
        }
    }

    private enum Layout {
        static let textBottomPadding: CGFloat = 20
        static let lineSpacing: CGFloat = 2
        static let verticalImagePadding: CGFloat = 7
        static let imageSize: CGFloat = 8
        static let imageTrailingPadding: CGFloat = 22
    }
}

extension InActiveFastingListView.ViewData {
    static var mock: InActiveFastingListView.ViewData {
        .init(type: .number(1),
              title: "InActiveFastingArticle.list.howToPrepareForFasting.1",
              subtitle: "InActiveFastingArticle.list.howToPrepareForFasting.1")
    }
}

#Preview {
    ScrollView {
        InActiveFastingListView(viewData: .mock)
    }
}
