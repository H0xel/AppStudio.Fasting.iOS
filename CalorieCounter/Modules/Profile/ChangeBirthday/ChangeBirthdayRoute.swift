//
//  ChangeBirthdayRoute.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI
import AppStudioNavigation

struct ChangeBirthdayRoute: Route {

    let birthday: Date
    let onBack: () -> Void
    let onSave: (Date) -> Void

    var view: AnyView {
        ChangeBirthdayView(initialBirthday: birthday,
                           onBackTap: onBack,
                           onSave: onSave)
        .eraseToAnyView()
    }
}
