//
//  InActiveFastingWidgetState.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import Foundation

public struct InActiveFastingWidgetState {
    let title: String
    let subtitle: String
    let onButtonTap: () -> Void
    let onSettingsTap: () -> Void

    public init(title: String,
                subtitle: String,
                onButtonTap: @escaping () -> Void,
                onSettingsTap: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.onButtonTap = onButtonTap
        self.onSettingsTap = onSettingsTap
    }
}

extension InActiveFastingWidgetState {
    static var mock: InActiveFastingWidgetState {
        .init(title: "Next fast in",
              subtitle: "00:02:33",
              onButtonTap: {},
              onSettingsTap: {})
    }
}
