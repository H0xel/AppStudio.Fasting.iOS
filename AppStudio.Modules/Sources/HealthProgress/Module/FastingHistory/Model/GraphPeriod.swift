//
//  GraphPeriod.swift
//  
//
//  Created by Amakhin Ivan on 19.03.2024.
//

import UIKit
import Charts

enum GraphPeriod: String, CaseIterable {
    case week
    case month
    case threeMonths

    var title: String {
        "FastingHistoryScreen.period.\(rawValue)".localized(bundle: .module)
    }

    var fastingHistoryVisibleBarsAreaAmount: Int {
        switch self {
        case .week: return 7
        case .month: return 31
        case .threeMonths: return 13
        }
    }

    var fastingHistoryVisibleDomain: Int {
        switch self {
        case .week: return 7
        case .month: return 31
        case .threeMonths: return 90
        }
    }

    var xValuesAmount: AxisMarkValues {
        switch self {
        case .week: return .stride(by: .day, count: 1)
        case .month: return .stride(by: .day, count: 4)
        case .threeMonths: return .stride(by: .day, count: 14)
        }
    }

    var fastingHistoryOffset: CGFloat {
        let chartTrailingPadding: CGFloat = 12
        let selectedLinWidth: CGFloat = 1 / 2
        return ((UIScreen.main.bounds.width - chartTrailingPadding) / CGFloat(fastingHistoryVisibleBarsAreaAmount)) / 2 - selectedLinWidth
    }

    var fastingChartXOffset: CGFloat {
        let chartTrailingPadding: CGFloat = 12
        let selectedLinWidth: CGFloat = 1 / 2
        switch self {
        case .week:
            return ((UIScreen.main.bounds.width - chartTrailingPadding) / CGFloat(fastingHistoryVisibleBarsAreaAmount)) / 4 - selectedLinWidth
        case .month:
            return -((UIScreen.main.bounds.width - chartTrailingPadding) / CGFloat(fastingHistoryVisibleBarsAreaAmount)) / 8 - selectedLinWidth
        case .threeMonths:
            return ((UIScreen.main.bounds.width - chartTrailingPadding) / CGFloat(fastingHistoryVisibleBarsAreaAmount)) / 6 - selectedLinWidth
        }

    }

    var fastingHistoryBarWidth: CGFloat {
        switch self {
        case .week, .threeMonths: return 16
        case .month: return 7
        }
    }

    var format: Date.FormatStyle {
        switch self {
        case .week: return .dateTime.weekday()
        case .month: return .dateTime.day()
        case .threeMonths: return .dateTime.day().month(.narrow)
        }
    }

    var unit: Calendar.Component {
        switch self {
        case .week, .month: return .day
        case .threeMonths: return .weekOfMonth
        }
    }
}
