//
//  EnvironmentValues+extensions.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.01.2024.
//

import SwiftUI

extension EnvironmentValues {
    var id: UUID {
        get { self[IdKey.self] }
        set { self[IdKey.self] = newValue }
    }

    var isCurrentTab: Bool {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}

private enum CurrentTabKey: EnvironmentKey {
    static let defaultValue = false
}

private enum IdKey: EnvironmentKey {
    static let defaultValue = UUID()
}
