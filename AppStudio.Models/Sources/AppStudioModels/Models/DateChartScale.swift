//
//  DateChartScale.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import Foundation

public enum DateChartScale: String, CaseIterable {
    case week
    case month
    case threeMonth

    public var visibleDomain: Int {
        86400 * numberOfDays + 18000
    }

    public var numberOfDays: Int {
        switch self {
        case .week: 7
        case .month: 30
        case .threeMonth: 90
        }
    }

    public var dateFormat: String {
        switch self {
        case .week: "eee"
        case .month: "dd"
        case .threeMonth: "MMMdd"
        }
    }

    public var title: String {
        "DateChartScale.\(rawValue)".localized(bundle: .module)
    }
}
