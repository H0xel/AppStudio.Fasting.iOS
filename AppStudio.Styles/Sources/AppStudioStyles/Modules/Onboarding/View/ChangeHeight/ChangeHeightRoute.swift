//
//  ChangeHeightRoute.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioModels

public struct ChangeHeightRoute: Route {

    private let height: HeightMeasure
    private let showDescription: Bool
    private let onBack: () -> Void
    private let onSave: (HeightMeasure) -> Void

    public init(height: HeightMeasure,
                showDescription: Bool,
                onBack: @escaping () -> Void,
                onSave: @escaping (HeightMeasure) -> Void) {
        self.height = height
        self.onBack = onBack
        self.onSave = onSave
        self.showDescription = showDescription
    }

    public var view: AnyView {
        ChangeHeightView(initialHeight: height,
                         showDescription: showDescription,
                         onBackTap: onBack,
                         onSaveTap: onSave)
            .eraseToAnyView()
    }
}
