//  
//  FastingHistoryInput.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//

import Foundation
import AppStudioModels
import WaterCounter
import Combine

struct FastingHistoryInput {
    // add Input parameters here
    let context: Context
    let historyData: FastingHistoryData
    let chartItems:  AnyPublisher<[FastingHistoryChartItem], Never>
    let inputHistoryPublisher: AnyPublisher<FastingHealthProgressInput, Never>

    enum Context: Equatable {
        case fasting
        case water(WaterUnits)

        var title: String {
            switch self {
            case .fasting:
                "FastingHistoryScreen.fasting.title".localized(bundle: .module)
            case .water:
                "FastingHistoryScreen.water.title".localized(bundle: .module)
            }
        }

        var graphDescription: String {
            switch self {
            case .fasting:
                "FastingHistoryScreen.fasting.goal".localized(bundle: .module)
            case .water:
                "FastingHistoryScreen.water.goal".localized(bundle: .module)
            }
        }

        var yAxisStride: Double {
            switch self {
            case .fasting:
                return 5
            case .water(let waterUnits):
                switch waterUnits {
                case .liters:
                    return 0.5
                case .ounces:
                    return 20
                }
            }
        }
    }
}
