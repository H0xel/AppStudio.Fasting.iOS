//  
//  FreeUsageServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import Foundation
import Dependencies
import MunicornFoundation

private let usageDatesKey = "usageDatesKey"

class FreeUsageServiceImpl: FreeUsageService {

    @Dependency(\.cloudStorage) private var cloudStorage

    func canAddToDay(_ dayDate: Date) -> Bool {
        let dates = cloudStorage.usageDates
        if dates.count < 3 {
            return true
        }
        return dates.contains(dayDate)
    }

    func insertDate(date: Date) {
        if cloudStorage.usageDates.count < 3 {
            cloudStorage.usageDates.insert(date)
        }
    }
}

private extension CloudStorage {
    var usageDates: Set<Date> {
        get {
            let json = get(key: usageDatesKey, defaultValue: "")
            let dates = try? Set<Date>(json: json)
            return dates ?? []
        }
        set { set(key: usageDatesKey, value: newValue.json()) }
    }
}