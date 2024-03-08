//
//  ActiveFastingWidgetState.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

public protocol FastingWidgetPhase {
    var title: String { get }
    var backgroundColor: Color { get }
    var timeRange: ClosedRange<TimeInterval> { get }
    var whiteImage: Image { get }
}

public struct ActiveFastingWidgetState {
    let title: String
    let startDate: Date
    let finishDate: Date
    let phases: [FastingWidgetPhase]
    let onEndFastingTap: () -> Void
    let onSettingsTap: () -> Void

    public init(title: String,
                startDate: Date,
                finishDate: Date,
                phases: [FastingWidgetPhase],
                onEndFastingTap: @escaping () -> Void,
                onSettingsTap: @escaping () -> Void) {
        self.title = title
        self.startDate = startDate
        self.finishDate = finishDate
        self.phases = phases
        self.onEndFastingTap = onEndFastingTap
        self.onSettingsTap = onSettingsTap
    }
}

extension ActiveFastingWidgetState {
    static var mock: ActiveFastingWidgetState {
        .init(title: "You've fasted for",
              startDate: .now.adding(.hour, value: -8),
              finishDate: .now,
              phases: [],
              onEndFastingTap: {},
              onSettingsTap: {})
    }
}
