//
//  AddIngredientTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI

struct AddIngredientTextField: View {

    let meal: Meal
    let onTap: (String) -> Void
    let onBarcodeScan: (Bool) -> Void
    let onDismissFocus: () -> Void
    @State private var text = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        FoodLogTextField(text: $text,
                         context: .addIngredients(meal),
                         isDisableEditing: false,
                         showTopBorder: false,
                         isBarcodeShown: true,
                         onTap: onTap,
                         onBarcodeScan: onBarcodeScan)
        .focused($isFocused)
        .aligned(.bottom)
        .onAppear {
            isFocused = true
        }
        .onChange(of: isFocused) { isFocused in
            if !isFocused {
                onDismissFocus()
            }
        }
    }
}

#Preview {
    AddIngredientTextField(meal: .mock, onTap: { _ in }, onBarcodeScan: { _ in }, onDismissFocus: {})
}
