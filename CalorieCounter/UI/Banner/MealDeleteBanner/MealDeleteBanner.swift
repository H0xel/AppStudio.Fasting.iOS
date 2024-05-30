//
//  MealDeleteBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct MealDeleteBanner: Banner {
    let editType: MealEditType
    let onCancel: () -> Void
    let onDelete: () -> Void
    let onEdit: (() -> Void)?

    var view: AnyView {
        HStack(spacing: .zero) {
            Button(action: onCancel) {
                Image.bannerCloseButton
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .cancelButtonSize, height: .cancelButtonSize)
                    .padding(.vertical, .cancelVerticalPadding)
                    .padding(.horizontal, .cancelHorizontalPadding)
            }

            Rectangle()
                .stroke(lineWidth: .dividerWidth / 2.0)
                .frame(width: .dividerWidth, height: .dividerHeight)
                .foregroundStyle(Color.separator)

            Spacer()

            if let editButtonTitle = editType.editButtonTitle, let onEdit {
                Button(action: onEdit) {
                    MealDeleteBannerButton(image: Image.bannerEdit, title: editButtonTitle)
                }
                Spacer()
                Spacer()
            }

            Button(action: onDelete) {
                MealDeleteBannerButton(image: Image.bannerTrash, title: editType.deleteButtonTitle)
            }

            Spacer()
            Spacer()
                .frame(width: 56)
        }
        .font(.poppins(.buttonText))
        .padding(.top, 8)
        .background(.white)
        .aligned(.bottom)
        .eraseToAnyView()
    }

    var transition: AnyTransition {
        .move(edge: .bottom)
    }

    var animation: Animation? {
        .bouncy
    }
}

private extension MealDeleteBanner {
    enum Localization {
        static let cancel: LocalizedStringKey = "CancelTitle"
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let dividerWidth: CGFloat = 0.5
    static let dividerHeight: CGFloat = 47
    static let cancelButtonSize: CGFloat = 32
    static let cancelVerticalPadding: CGFloat = 7.5
    static let cancelHorizontalPadding: CGFloat = 12
    static let padding: CGFloat = 16
}
