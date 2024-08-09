//  
//  RateAppServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 09.07.2024.
//

import Dependencies
import MunicornFoundation
import Foundation

private let lastRateUsDialogShowDateKey = "lastRateUsDialogShowDateKey"
private let userDidRateUsKey = "userDidRateUsKey"

class RateAppServiceImpl: RateAppService {
    @Dependency(\.cloudStorage) private var cloudStorage

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
            return true
        }
        return date.adding(.month, value: 1) < .now
    }

    func rateUsDialogShown() {
        cloudStorage.lastRateUsDialogShowDate = .now
    }

    func userRatedUs() {
        cloudStorage.didUserRateUs = true
    }
}

private extension CloudStorage {

    var lastRateUsDialogShowDate: Date? {
        get { get(key: lastRateUsDialogShowDateKey) }
        set { set(key: lastRateUsDialogShowDateKey, value: newValue) }
    }

    var didUserRateUs: Bool {
        get { get(key: userDidRateUsKey, defaultValue: false) }
        set { set(key: userDidRateUsKey, value: newValue) }
    }
}
