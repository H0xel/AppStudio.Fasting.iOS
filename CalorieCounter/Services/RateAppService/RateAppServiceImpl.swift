//  
//  RateAppServiceImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import Dependencies
import MunicornFoundation
import Foundation

private let lastRateUsDialogShowDateKey = "lastRateUsDialogShowDateKey"
private let lastRateDateKey = "RateAppService.cloudStorage.lastRateDateKey"
private let userDidRateUsKey = "userDidRateUsKey"

class RateAppServiceImpl: RateAppService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.mealRepository) private var mealRepository

    var canShowAppStoreReviewDialog: Bool {
        guard !cloudStorage.didUserRateUs, let date = cloudStorage.lastRateUsDialogShowDate else {
            return false
        }
        return date.add(days: 1) < .now
    }

    func canShowRateUsDialog() async throws -> Bool {
        guard !cloudStorage.didUserRateUs else {
            return false
        }
        guard let date = cloudStorage.lastRateUsDialogShowDate else {
            return try await mealRepository.firstMeal() != nil
        }
        return date.adding(.month, value: 1) < .now
    }

    func rateUsDialogShown() {
        cloudStorage.lastRateUsDialogShowDate = .now
    }

    func userRatedUs() {
        cloudStorage.didUserRateUs = true
    }

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

private extension CloudStorage {

    var lastRateDate: Date? {
        get { get(key: lastRateDateKey) }
        set { set(key: lastRateDateKey, value: newValue) }
    }

    var lastRateUsDialogShowDate: Date? {
        get { get(key: lastRateUsDialogShowDateKey) }
        set { set(key: lastRateUsDialogShowDateKey, value: newValue) }
    }

    var didUserRateUs: Bool {
        get { get(key: userDidRateUsKey, defaultValue: false) }
        set { set(key: userDidRateUsKey, value: newValue) }
    }
}
