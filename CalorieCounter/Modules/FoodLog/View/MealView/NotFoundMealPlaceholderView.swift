//
//  NotFoundMealPlaceholderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 23.01.2024.
//
import SwiftUI

struct NotFoundMealPlaceholderView: View {
    let barcode: String
    let action: (Action) -> Void

    var body: some View {
        VStack(spacing: .spacing) {
            Text(Localization.title)
                .foregroundStyle(Color.studioBlackLight)
                .font(.poppinsMedium(.body))
                .multilineTextAlignment(.center)

            Text(barcode)
                .foregroundStyle(Color.studioGreyPlaceholder)
                .font(.poppins(.description))

            HStack(spacing: .spacing) {
                Button("CloseTitle") {
                    action(.close)
                }
                .background()
                .padding(.vertical, .buttonVerticalPadding)
                .padding(.horizontal, .buttonHorizontalPadding)
                .border(configuration: .init(cornerRadius: .buttonCornerRadius,
                                             color: Color.studioGreyStrokeFill,
                                             lineWidth: .borderLineWidth))

                Button("CreateFoodTitle") {
                    action(.createFood(barcode: barcode))
                }
                .padding(.vertical, .buttonVerticalPadding)
                .padding(.horizontal, .buttonHorizontalPadding)
                .background(Color.studioGrayFillProgress)
                .continiousCornerRadius(.buttonCornerRadius)
            }
            .font(.poppins(.description))
            .foregroundStyle(Color.studioBlackLight)
            .padding(.top, .spacing)
        }
        .aligned(.centerHorizontaly)
        .padding(.padding)
        .background(Color.white)
        .continiousCornerRadius(.cornerRadius)
    }
}

extension NotFoundMealPlaceholderView {
    enum Action {
        case close
        case createFood(barcode: String)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let imageHorizontalPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let padding: CGFloat = 16
    static let borderLineWidth: CGFloat = 0.5

    static let buttonVerticalPadding: CGFloat = 15
    static let buttonHorizontalPadding: CGFloat = 24
    static let buttonCornerRadius: CGFloat = 44
}

private extension NotFoundMealPlaceholderView {
    enum Localization {
        static let title = NSLocalizedString("NotFoundMealPlaceholderView.title",
                                             comment: "Nothing found with this barcode")
    }
}

#Preview {
    NotFoundMealPlaceholderView(barcode: "1234567") { _ in }
        .border(configuration: .error)
}
