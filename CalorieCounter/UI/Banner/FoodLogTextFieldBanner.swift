//
//  FoodLogTextFieldBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 11.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct FoodLogTextFieldBanner: Banner {

    let onTap: () -> Void
    let onBarcodeScan: (Bool) -> Void

    var view: AnyView {
        FoodLogTextField(isDisableEditing: true,
                         onTap: { _ in onTap() },
                         onBarcodeScan: onBarcodeScan)
            .aligned(.bottom)
            .eraseToAnyView()
    }
}
