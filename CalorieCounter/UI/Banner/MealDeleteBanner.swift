//
//  MealDeleteBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct MealDeleteBanner: Banner {

    let title: LocalizedStringKey
    let onCancel: () -> Void
    let onDelete: () -> Void

    var view: AnyView {
        HStack(spacing: .spacing) {
            Button(action: onCancel) {
                Text(Localization.cancel)
                    .foregroundStyle(.accent)
                    .padding(.vertical, .buttonVerticalPadding)
                    .padding(.horizontal, .cancelHorizontalPadding)
            }

            Button(action: onDelete) {
                Text(title)
                    .foregroundStyle(.white)
                    .padding(.vertical, .buttonVerticalPadding)
                    .aligned(.centerHorizontaly)
                    .background(Color.studioRed)
                    .continiousCornerRadius(.cornerRadius)
            }
        }
        .font(.poppins(.buttonText))
        .padding(.padding)
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
    static let buttonVerticalPadding: CGFloat = 25
    static let cancelHorizontalPadding: CGFloat = 24
    static let cornerRadius: CGFloat = 20
    static let padding: CGFloat = 16
}
