//
//  FoodLogTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioUI

enum FoodLogTextFieldContext {
    case addMeal
    case addIngredients(Meal)
}

struct FoodLogTextField: View {
    var context: FoodLogTextFieldContext = .addMeal
    var isDisableEditing = false
    var isBarcodeShown = true
    let onTap: (String) -> Void
    let onBarcodeScan: () -> Void
    @State private var text: String = ""

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let mealName {
                HStack(spacing: .titleSpacing) {
                    Text(headerTitle)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGreyText)

                    Text(mealName)
                        .font(.poppinsBold(.description))
                        .lineLimit(1)
                        .foregroundStyle(Color.studioGreyText)
                }
                .padding(.leading, .titleLeadingPadding)
                .padding(.bottom, .titleBottomPadding)
            }
            HStack(alignment: .bottom, spacing: .spacing) {
                HStack(alignment: .center, spacing: .spacing) {
                    TextField(
                        "",
                        text: .init(get: { text },
                                    set: { text in
                                        self.text = text
                                    }),
                        prompt: Text(promt)
                            .foregroundColor(.studioGreyPlaceholder),
                        axis: .vertical
                    )
                    .focused($isFocused)
                    .submitLabel(.done)
                    .modifier(NoNewLineTextFieldModifier(text: $text, onSubmit: log))
                    .font(.poppins(.body))
                    .lineLimit(5)
                    .padding(.vertical, .emptyStateVerticalPadding)
                }
                .padding(.horizontal, .emptyStateHorizontalPadding)
                .background(Color.studioGreyFillCard)
                .continiousCornerRadius(.textfieldCornerRadius)
                .disabled(isDisableEditing)
                .onTapGesture {
                    if isDisableEditing {
                        onTap("")
                    }
                }

                if !text.isEmpty {
                    FoodLogTextFieldButton(isAccent: true, image: .arrowUp, onTap: log)
                } else if isBarcodeShown {
                    FoodLogTextFieldButton(image: .barcode, onTap: onBarcodeScan)
                }
            }
        }
        .padding(.emptyStatePadding)
        .foregroundStyle(.accent)
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
        .modifier(TopBorderModifier())
    }

    private var headerTitle: String {
        Localization.newIngredientsTitle
    }

    private var mealName: String? {
        if case let .addIngredients(meal) = context {
            return "\(meal.mealItem.mealName)"
        }
        return nil
    }

    private var promt: String {
        switch context {
        case .addMeal:
            Localization.notFocusedPlaceholder
        case .addIngredients:
            ""
        }
    }

    private var isEmptyState: Bool {
        !isFocused && text.isEmpty || isDisableEditing
    }

    private func log() {
        onTap(text)
        text = ""
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 20
    static let leadingPadding: CGFloat = 24
    static let notFocusedLeadingPadding: CGFloat = 0
    static let trailingPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let textfieldCornerRadius: CGFloat = 20
    static let spacing: CGFloat = 4
    static let arrowBottomPadding: CGFloat = 14
    static let emptyStateVerticalPadding: CGFloat = 8
    static let emptyStatePadding: CGFloat = 8
    static let emptyStateHorizontalPadding: CGFloat = 16
    static let emptyStateCornerRadius: CGFloat = 56
    static let titleSpacing: CGFloat = 4
    static let titleLeadingPadding: CGFloat = 16
    static let titleBottomPadding: CGFloat = 8
}

private extension FoodLogTextField {
    enum Localization {
        static let placeholder: LocalizedStringKey = "FoodLogScreen.textFieldPlaceholder"
        static let notFocusedPlaceholder = NSLocalizedString( "FoodLogScreen.notFocuesedTextFieldPlaceholder",
                                                              comment: "")
        static let newIngredientsTitle = NSLocalizedString( "FoodLogScreen.newIngredientsTitle", comment: "")
    }
}

#Preview {
    VStack(spacing: 0) {
        ZStack {
            Color.yellow
            FoodLogTextField(isBarcodeShown: true, onTap: { _ in }, onBarcodeScan: {})
        }
        ZStack {
            Color.yellow
            FoodLogTextField(context: .addIngredients(.mock), isBarcodeShown: true, onTap: { _ in }, onBarcodeScan: {})
        }
    }
}
