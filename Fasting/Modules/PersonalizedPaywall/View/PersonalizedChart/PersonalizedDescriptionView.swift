//
//  PersonalizedDescriptionView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedDescriptionView: View {
    let viewData: [ViewData]

    init(viewData: [ViewData]) {
        self.viewData = viewData + .staticDescriptions
    }

    var body: some View {
        VStack(spacing: .zero) {
            Text(Localization.title)
                .font(.poppins(.headerS))
                .padding(.bottom, Layout.titleBottomPadding)

            VStack(spacing: .zero) {
                ForEach(viewData) { content in
                    HStack(spacing: .zero) {
                        ZStack {
                            Rectangle()
                                .frame(width: Layout.rectangleSize, height: Layout.rectangleSize)
                                .continiousCornerRadius(Layout.rectangleCornerRadius)
                                .foregroundStyle(Color.studioGreen)

                            switch content.type {
                            case let .image(image):
                                image
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                            case let .text(text):
                                Text(text)
                                    .foregroundStyle(.white)
                                    .font(.poppins(11))
                            }
                        }
                        .padding(.trailing, Layout.trailingPadding)

                        Text(content.description)
                            .font(.poppins(.description))

                        Spacer()
                    }
                    .padding(.bottom, Layout.itemBottomPadding)
                }
            }
            .padding(.top, Layout.topPadding)
            .padding(.bottom, Layout.bottomPadding)
            .padding(.horizontal, Layout.contentHorizontalPAdding)
            .background(Color.studioGrayFillCard)
            .continiousCornerRadius(Layout.cornerRadius)
        }
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

extension PersonalizedDescriptionView {
    struct ViewData: Identifiable {
        let id = UUID().uuidString
        let type: ContentType
        let description: String
    }

    enum ContentType {
        case image(Image)
        case text(String)
    }
}

private extension PersonalizedDescriptionView {
    enum Layout {
        static let titleBottomPadding: CGFloat = 24
        static let rectangleSize: CGFloat = 28
        static let rectangleCornerRadius: CGFloat = 8
        static let trailingPadding: CGFloat = 16
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 4
        static let contentHorizontalPAdding: CGFloat = 20
        static let cornerRadius: CGFloat = 20
        static let itemBottomPadding: CGFloat = 20
        static let horizontalPadding: CGFloat = 32
    }

    enum Localization {
        static let title: LocalizedStringKey = "PersonalizedPaywall.whatYoullGet"
    }
}


#Preview {
    PersonalizedDescriptionView(viewData: .staticDescriptions)
}

extension [PersonalizedDescriptionView.ViewData] {
    static var staticDescriptions: [PersonalizedDescriptionView.ViewData] {
        [
            .init(type: .image(.highlighter),
                  description: NSLocalizedString("PersonalizedPaywall.description.3", comment: "3 description")),
            .init(type: .image(.birthdayCakeFill),
                  description: NSLocalizedString("PersonalizedPaywall.description.4", comment: "4 description")),
            .init(type: .image(.arrowshapeUpFill),
                  description: NSLocalizedString("PersonalizedPaywall.description.5", comment: "5 description")),
            .init(type: .image(.figure),
                  description: NSLocalizedString("PersonalizedPaywall.description.6", comment: "6 description")),
            .init(type: .image(.wandAndRays),
                  description: NSLocalizedString("PersonalizedPaywall.description.7", comment: "7 description")),
            .init(type: .image(.checkmarkShieldFill),
                  description: NSLocalizedString("PersonalizedPaywall.description.8", comment: "8 description"))
        ]
    }
}
