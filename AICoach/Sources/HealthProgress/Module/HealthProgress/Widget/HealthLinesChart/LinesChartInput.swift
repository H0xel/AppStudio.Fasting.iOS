//
//  LinesChartInput.swift
//
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import Foundation
import AppStudioModels

struct LinesChartInput {
    let widgetInput: HealthWidgetInput
    let items: [LineChartItem]
}

extension LinesChartInput {
    static func weight(with items: [LineChartItem]) -> LinesChartInput {
        .init(widgetInput: .weight,
              items: items)
    }
}
