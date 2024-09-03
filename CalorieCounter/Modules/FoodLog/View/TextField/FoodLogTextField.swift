//
//  FoodLogTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioStyles
import Dependencies

enum FoodLogTextFieldContext {
    case addMeal
    case addIngredients(Meal)
}

struct FoodLogTextField: View {
    @Binding var text: String
    @Dependency(\.cameraAccessService) private var cameraAccessService

    var context: FoodLogTextFieldContext = .addMeal
    var isDisableEditing = false
    var showTopBorder = true
    var isBarcodeShown = true
    let onTap: (String) -> Void
    let onBarcodeScan: (Bool) -> Void

    @FocusState private var isFocused: Bool
    @State private var numberOfLines = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let mealName {
                FoodLogTextFieldTitleView(mealName: mealName)
            }
            HStack(alignment: .bottom, spacing: .spacing) {
                BindingTextField(text: $text, placeholder: promt)
                    .withViewHeightPreferenceKey
                    .focused($isFocused)
                    .submitLabel(.return)
                    .modifier(NoNewLineTextFieldModifier(availableNumberOfLines: 5,
                                                         text: $text,
                                                         onSubmit: log))
                    .font(.poppins(.body))
                    .lineLimit(5)
                    .padding(.vertical, .emptyStateVerticalPadding)
                    .padding(.horizontal, .emptyStateHorizontalPadding)
                    .background(Color.studioGreyFillProgress)
                    .continiousCornerRadius(numberOfLines > 1 
                                            ? .textfieldMultilineCornerRadius
                                            : .textfieldCornerRadius
                    )
                    .disabled(isDisableEditing)
                    .onTapGesture {
                        if isDisableEditing {
                            onTap("")
                        }
                    }
                if !text.isEmpty {
                    FoodLogTextFieldButton(isAccent: true, image: .sparkles, onTap: log)
                } else if isBarcodeShown {
                    FoodLogTextFieldButton(image: .barcode) {
                        Task {
                            let cameraAccessGranted = await cameraAccessService.requestAccess()
                            onBarcodeScan(cameraAccessGranted)
                        }
                    }
                }
            }
        }
        .padding(.emptyStatePadding)
        .foregroundStyle(.accent)
        .background(.white)
        .corners([.topLeft, .topRight], with: showTopBorder ? .cornerRadius : .zero)
        .modifier(TopBorderModifier(color: showTopBorder ? .studioGreyStrokeFill : .clear))
        .onViewHeightPreferenceKeyChange { height in
            numberOfLines = Int((height / .textLineHeight).rounded(.up))
        }
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

    private func log() {
        onTap(text)
        text = ""
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 20
    static let textfieldCornerRadius: CGFloat = 56
    static let textfieldMultilineCornerRadius: CGFloat = 16
    static let spacing: CGFloat = 4
    static let emptyStateVerticalPadding: CGFloat = 12
    static let emptyStatePadding: CGFloat = 10
    static let emptyStateHorizontalPadding: CGFloat = 16
    static let textLineHeight: CGFloat = 23
}

private extension FoodLogTextField {
    enum Localization {
        static let placeholder: LocalizedStringKey = "FoodLogScreen.textFieldPlaceholder"
        static let notFocusedPlaceholder = "FoodLogScreen.notFocuesedTextFieldPlaceholder".localized()
    }
}

#Preview {
    VStack(spacing: 0) {
        ZStack {
            Color.yellow
            FoodLogTextField(text: .constant(""), isBarcodeShown: true, onTap: { _ in }, onBarcodeScan: { _ in })
        }
        ZStack {
            Color.yellow
            FoodLogTextField(text: .constant(""), context: .addIngredients(.mock),
                             isBarcodeShown: true,
                             onTap: { _ in },
                             onBarcodeScan: { _ in })
        }
    }
}
