//
//  ChangeBirthdayRoute.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioNavigation

public struct ChangeBirthdayRoute: Route {

    private let birthday: Date
    private let showDescription: Bool
    private let onBack: () -> Void
    private let onSave: (Date) -> Void

    public init(birthday: Date,
                showDescription: Bool,
                onBack: @escaping () -> Void,
                onSave: @escaping (Date) -> Void) {
        self.birthday = birthday
        self.showDescription = showDescription
        self.onBack = onBack
        self.onSave = onSave
    }

    public var view: AnyView {
        ChangeBirthdayView(initialBirthday: birthday,
                           showDescription: showDescription,
                           onBackTap: onBack,
                           onSave: onSave)
        .eraseToAnyView()
    }
}
