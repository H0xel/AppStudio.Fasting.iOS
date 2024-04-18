//
//  DayFoodOutput.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 16.04.2024.
//

import Foundation
import AppStudioModels

enum DayFoodOutput {
    case banner
    case closeBanner
    case switchTabBar(isHidden: Bool)
    case dayProgress(date: Date, progress: DayProgress)
}
