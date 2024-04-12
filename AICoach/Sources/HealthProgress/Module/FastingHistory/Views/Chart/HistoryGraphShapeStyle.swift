//
//  HistoryGraphShapeStyle.swift
//
//
//  Created by Amakhin Ivan on 25.03.2024.
//

import SwiftUI
import AppStudioStyles
import AppStudioModels

struct HistoryGraphShapeStyle: ShapeStyle {
    let barItem: FastingHistoryChartItem
    let selectedPeriod: GraphPeriod
    let items: [FastingHistoryChartItem]

    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        switch selectedPeriod {
        case .week, .month:
            return barItem.stage.backgroundColor
        case .threeMonths:
            if barItem.stage == .water {
                return barItem.stage.backgroundColor
            }

            let filteredItems = self.items.filter {
                $0.date.year == barItem.date.year
                && $0.date.month == barItem.date.month
                && $0.date.week == barItem.date.week
            }

            let item = filteredItems.max { $0.stage.stageWeight < $1.stage.stageWeight }


            return barItem == item
            ? (item?.stage.backgroundColor ?? Color.clear)
            : Color.clear
        }
    }
}
