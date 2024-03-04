//
//  NotFoundMealPlaceholderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 23.01.2024.
//
import SwiftUI

struct NotFoundMealPlaceholderView: View {
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: .spacing) {
            Image.magnifier
                .padding(.horizontal, .imageHorizontalPadding)

            Text(Localization.title)
                .foregroundStyle(.accent)
                .font(.poppins(.body))

            Spacer()

            Button(action: onClose, label: {
                Image.close
                    .foregroundStyle(Color.studioGrayText)
            })
        }
        .padding(.padding)
        .background(Color.white)
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let imageHorizontalPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let padding: CGFloat = 16
}

private extension NotFoundMealPlaceholderView {
    enum Localization {
        static let title = NSLocalizedString("NotFoundMealPlaceholderView.title",
                                             comment: "Nothing found with this barcode")
    }
}
