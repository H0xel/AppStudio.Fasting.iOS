//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation
import SwiftUI
import AppStudioStyles

struct HealthWidgetInput: Equatable {
    let title: String
    let subtitle: String
    let isExploreButtonPresented: Bool
    let emptyStateInput: ChartEmptyStateInput
    let icon: Image

    static func == (lhs: HealthWidgetInput, rhs: HealthWidgetInput) -> Bool {
        lhs.title == rhs.title
    }
}

extension HealthWidgetInput {
    var monetizationImage: Image {
        if self == .weight {
            return Image(.monetizationWeight)
        }

        if self == .fasting {
            return Image(.monetizationFasting)
        }

        return Image(.monetizationWater)
    }

    var monetizationTitle: String {
        if self == .fasting {
            return "Widget.title.unlockFastingHistory".localized(bundle: .module)
        }
        return "Widget.title.enableForOurUsers".localized(bundle: .module)
    }
}

extension HealthWidgetInput {
    static var weight: HealthWidgetInput {
        .init(title: "FastingHealthProgressScreen.weightTitle".localized(bundle: .module),
              subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
              isExploreButtonPresented: .isExploreButtonAvailable,
              emptyStateInput: .weight,
              icon: .widgetInfo)
    }

    static var fasting: HealthWidgetInput {
        .init(title: "FastingHealthProgressScreen.fastingTitle".localized(bundle: .module),
              subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
              isExploreButtonPresented: .isExploreButtonAvailable,
              emptyStateInput: .fasting,
              icon: .widgetInfo)
    }

    static var water: HealthWidgetInput {
        .init(title: "FastingHealthProgressScreen.waterTitle".localized(bundle: .module),
              subtitle: "FastingHealthProgressScreen.lastSevenDays".localized(bundle: .module),
              isExploreButtonPresented: .isExploreButtonAvailable,
              emptyStateInput: .water,
              icon: .widgetSettings)
    }
}

private extension Bool {
    static var isExploreButtonAvailable: Bool {
        if #available(iOS 17.0, *) {
            return true
        }
        return false
    }
}
