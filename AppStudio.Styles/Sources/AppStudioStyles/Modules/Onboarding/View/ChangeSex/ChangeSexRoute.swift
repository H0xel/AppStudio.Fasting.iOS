//
//  ChangeSexRoute.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioModels

public struct ChangeSexRoute: Route {

    private let sex: Sex
    private let showDescription: Bool
    private let onBackTap: () -> Void
    private let onSave: (Sex) -> Void

    public init(sex: Sex,
                showDescription: Bool,
                onBackTap: @escaping () -> Void,
                onSave: @escaping (Sex) -> Void) {
        self.sex = sex
        self.showDescription = showDescription
        self.onBackTap = onBackTap
        self.onSave = onSave
    }

    public var view: AnyView {
        ChangeSexView(initialSex: sex,
                      showDescription: showDescription,
                      onBackTap: onBackTap,
                      onSaveTap: onSave)
        .eraseToAnyView()
    }
}
