//  
//  RateAppServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import Dependencies
import MunicornFoundation
import Foundation

class RateAppServiceImpl: RateAppService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.mealRepository) private var mealRepository

    func rateAppWindowShown() {
        Task { @MainActor in
            cloudStorage.lastRateDate = .now
        }
    }

    func canShowRateAppWindow() async throws -> Bool {
        if let lastDate = cloudStorage.lastRateDate {
            let days = lastDate.distance(to: .now).hours / 24 / 30
            if days < 90 {
                return false
            }
        }
        let firstMeals = try await mealRepository.meals(count: 10)
        if firstMeals.count == 10 {
            return true
        }
        return false
    }
}

fileprivate let lastRateDateKey = "RateAppService.cloudStorage.lastRateDateKey"
private extension CloudStorage {

    var lastRateDate: Date? {
        get { get(key: lastRateDateKey) }
        set { set(key: lastRateDateKey, value: newValue) }
    }
}
