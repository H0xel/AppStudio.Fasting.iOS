//
//  ChangeSexRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct ChangeSexRoute: Route {

    let sex: Sex
    let onBackTap: () -> Void
    let onSave: (Sex) -> Void

    var view: AnyView {
        ChangeSexView(initialSex: sex,
                      onBackTap: onBackTap,
                      onSaveTap: onSave)
        .eraseToAnyView()
    }
}
