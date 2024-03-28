//
//  FastingWidgetInitializer+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 14.03.2024.
//

import Foundation
import FastingWidget
import Dependencies

extension FastingWidgetInitializer: AppInitializer {
    func initialize() {
        @Dependency(\.fastingWidgetService) var fastingWidgetService
        initialize(fastingWidgetService: fastingWidgetService)
    }
}
