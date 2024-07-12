//
//  ProductIdsApp.swift
//
//
//  Created by Amakhin Ivan on 29.04.2024.
//

import Foundation

public enum ProductIdsApp {
    case fasting
    case calorieCounter
}

extension ProductIdsApp {
    var localIds: [String] {
        switch self {
        case .fasting:
            return [
                "com.municorn.Fasting.weekly_exp_1",
                "com.municorn.Fasting.weekly_exp_2",
                "com.municorn.Fasting.monthly_exp_1",
                "com.municorn.Fasting.yearly_exp_1",
                "com.municorn.Fasting.yearly_exp_6",
                "com.municorn.Fasting.weekly_exp_3",
                "com.municorn.Fasting.weekly_exp_4",
                "com.municorn.Fasting.weekly_exp_5",
                "com.municorn.Fasting.weekly_exp_7",
                "com.municorn.Fasting.3monthly_exp_7",
                "com.municorn.Fasting.yearly_exp_7"
            ]
        case .calorieCounter:
            return [
                "com.municorn.CalorieCounter.weekly_exp_1",
                "com.municorn.CalorieCounter.3monthly_exp_1",
                "com.municorn.CalorieCounter.yearly_exp_1",
                "com.municorn.CalorieCounter.weekly_exp_2"
            ]
        }
    }

    var defaultIds: [String] {
        switch self {
        case .fasting:
            [
                "com.municorn.Fasting.weekly_exp_7",
                "com.municorn.Fasting.3monthly_exp_7",
                "com.municorn.Fasting.yearly_exp_7"
            ]
        case .calorieCounter:
            [
                "com.municorn.CalorieCounter.weekly_exp_1",
                "com.municorn.CalorieCounter.3monthly_exp_1",
                "com.municorn.CalorieCounter.yearly_exp_1"
            ]
        }
    }
}
