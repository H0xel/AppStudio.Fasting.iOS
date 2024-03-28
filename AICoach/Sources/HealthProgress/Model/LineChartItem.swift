//
//  LineChartItem.swift
//
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import AppStudioModels
import AppStudioStyles

extension LineChartItem {

    static func trueWeight(values: [LineChartValue]) -> LineChartItem {
        .init(title: "LineChartItem.trueWeight".localized(bundle: .module),
              lineWidth: 4,
              lineColor: .studioBlue,
              values: values)
    }

    static func scaleWeight(values: [LineChartValue]) -> LineChartItem {
        .init(title: "LineChartItem.scaleWeight".localized(bundle: .module),
              lineWidth: 2,
              lineColor: .studioGreyStrokeFill,
              values: values)
    }

    var empty: LineChartItem {
        .init(title: title,
              lineWidth: 0,
              lineColor: lineColor,
              values: values)
    }
}

