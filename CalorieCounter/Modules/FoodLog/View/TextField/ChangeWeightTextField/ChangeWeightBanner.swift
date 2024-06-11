//
//  ChangeWeightBanner.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 31.05.2024.
//

import SwiftUI
import AppStudioNavigation

struct ChangeWeightBanner: Banner {

    let title: String
    let initialWeight: Double
    let onWeightChange: (Double) -> Void
    let onCancel: () -> Void

    var view: AnyView {
        ChangeWeightTextField(title: title,
                              initialWeight: initialWeight,
                              onWeightChange: onWeightChange,
                              onCancel: onCancel)
            .eraseToAnyView()
    }
}
