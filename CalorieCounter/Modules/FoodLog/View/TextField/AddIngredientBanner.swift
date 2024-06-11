//
//  AddIngredientBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation

struct AddIngredientBanner: Banner {

    let meal: Meal
    let onTap: (String) -> Void
    let onBarcodeScan: (Bool) -> Void
    let onDismissFocus: () -> Void

    var view: AnyView {
        AddIngredientTextField(meal: meal,
                               onTap: onTap,
                               onBarcodeScan: onBarcodeScan,
                               onDismissFocus: onDismissFocus)
        .aligned(.bottom)
        .eraseToAnyView()
    }
}
