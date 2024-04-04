//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation
import SwiftUI
import AppStudioStyles

struct HealthWidgetInput {
    let title: String
    let subtitle: String
    let isExploreButtonPresented: Bool
    let emptyStateInput: ChartEmptyStateInput
    let icon: Image
}

extension HealthWidgetInput {
    static var weight: HealthWidgetInput {
        let canExplore = if #available(iOS 17.0, *) { true } else { false }
        return .init(title: "FastingHealthProgressScreen.weightTitle".localized(bundle: .module),
                     subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
                     isExploreButtonPresented: canExplore,
                     emptyStateInput: .weight,
                     icon: .widgetInfo)
    }

    static var fasting: HealthWidgetInput {
        .init(title: "FastingHealthProgressScreen.fastingTitle".localized(bundle: .module),
              subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
              isExploreButtonPresented: false,
              emptyStateInput: .fasting,
              icon: .widgetInfo)
    }

    static var water: HealthWidgetInput {
        .init(title: "FastingHealthProgressScreen.waterTitle".localized(bundle: .module),
              subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
              isExploreButtonPresented: false,
              emptyStateInput: .water,
              icon: .widgetSettings)
    }
}
