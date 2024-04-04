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

    var yScaleDomain: ClosedRange<Double> {
        let items = items.flatMap { $0.values }
        guard let min = items.min(by: { $0.value < $1.value }),
              let max = items.max(by: { $0.value < $1.value }) else {
            return 0 ... 0
        }
        return min.value - 2 ... max.value + 2
    }

    var isEmpty: Bool {
        items.reduce(0) { $0 + $1.lineWidth } == 0
    }
}

extension LinesChartInput {
    static func weight(with items: [LineChartItem]) -> LinesChartInput {
        .init(widgetInput: .weight,
              items: items)
    }
}
