//
//  NotFoundAISearchPlaceholderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 14.08.2024.
//

import SwiftUI

struct NotFoundAISearchPlaceholderView: View {
    let request: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: .spacing) {
                // Title
                VStack(spacing: .spacing) {
                    HStack(spacing: .wordSpacing) {
                        Text(Localization.part1)
                            .font(.poppinsMedium(.body))
                        Image.sparkles
                            .font(.subheadline.weight(.medium))
                        Text(Localization.part2)
                            .font(.poppinsMedium(.body))
                    }
                    .foregroundStyle(Color.studioBlackLight)
                    Text(Localization.part3)
                        .font(.poppinsMedium(.body))
                }
                .foregroundStyle(Color.studioBlackLight)

                // Subtitle, name of request
                Text(request)
                    .foregroundStyle(Color.studioGreyPlaceholder)
                    .font(.poppins(.description))
            }
            .aligned(.centerHorizontaly)
            .padding(.padding)
            .background(Color.white)
            .continiousCornerRadius(.cornerRadius)

            // Close button
            VStack(spacing: .zero) {
                HStack(spacing: .zero) {
                    Spacer()
                    Button(action: {
                        onClose()
                    }, label: {
                        Image.close
                            .foregroundStyle(Color.studioGreyPlaceholder)
                            .frame(width: .buttonSize, height: .buttonSize)
                            .padding(.buttonPadding)
                    })
                }
                Spacer()
            }
            .padding(.buttonOutsidePadding)
        }
    }
}

extension NotFoundAISearchPlaceholderView {
    enum Action {
        case close
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let padding: CGFloat = 16
    static let wordSpacing: CGFloat = 5
    static let buttonPadding: CGFloat = 7
    static let buttonOutsidePadding: CGFloat = 10
    static let buttonSize: CGFloat = 10
}

private extension NotFoundAISearchPlaceholderView {
    enum Localization {
        static let part1 = NSLocalizedString("NotFoundAISearchPlaceholderView.title.part1",
                                             comment: "Oops, AI")
        static let part2 = NSLocalizedString("NotFoundAISearchPlaceholderView.title.part2",
                                             comment: "Couldn't Recognize")

        static let part3 = NSLocalizedString("NotFoundAISearchPlaceholderView.title.part3",
                                             comment: "Your Food")
    }
}

#Preview {
    NotFoundAISearchPlaceholderView(request: " test") {}
}
