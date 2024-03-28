//
//  FastingProgressServiceDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import Foundation
import Dependencies
import FastingWidget

extension DependencyValues {
    var fastingWidgetService: FastingWidgetService {
        self[FastingWidgetServiceKey.self]
    }
}

private enum FastingWidgetServiceKey: DependencyKey {
    static let liveValue = FastingWidgetServiceImpl()
}
