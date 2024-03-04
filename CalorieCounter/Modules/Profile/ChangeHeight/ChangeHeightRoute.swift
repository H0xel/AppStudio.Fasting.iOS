//
//  ChangeHeightRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct ChangeHeightRoute: Route {

    let height: HeightMeasure
    let onBack: () -> Void
    let onSave: (HeightMeasure) -> Void

    var view: AnyView {
        ChangeHeightView(initialHeight: height,
                         onBackTap: onBack,
                         onSaveTap: onSave)
            .eraseToAnyView()
    }
}
