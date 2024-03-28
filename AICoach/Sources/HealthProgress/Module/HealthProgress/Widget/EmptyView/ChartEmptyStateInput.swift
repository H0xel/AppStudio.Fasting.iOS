//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation

struct ChartEmptyStateInput {
    let title: String
    let subtitle: String
    let buttonTitle: String?
}

extension ChartEmptyStateInput {
    static var weight: ChartEmptyStateInput {
        .init(title: "WeightWidgetEmptyView.title".localized(bundle: .module),
              subtitle: "WeightWidgetEmptyView.subtitle".localized(bundle: .module),
              buttonTitle: "WeightWidgetEmptyView.buttonTitle".localized(bundle: .module))
    }

    static var fasting: ChartEmptyStateInput {
        .init(title: "FastingWidgetEmptyView.title".localized(bundle: .module),
              subtitle: "FastingWidgetEmptyView.subtitle".localized(bundle: .module),
              buttonTitle: nil)
    }

    static var water: ChartEmptyStateInput {
        .init(title: "WaterWidgetEmptyView.title".localized(bundle: .module),
              subtitle: "WaterWidgetEmptyView.subtitle".localized(bundle: .module),
              buttonTitle: nil)
    }
}
