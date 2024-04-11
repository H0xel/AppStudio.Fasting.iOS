//
//  FastingFinishedCyclesLimitServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 24.11.2023.
//

import Dependencies

private let fastingFinishedCyclesLimitKey = "Fasting.fastingFinishedCyclesLimitKey"

class FastingFinishedCyclesLimitServiceImpl: FastingLimitService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.appCustomization) private var appCustomization

    var isLimited: Bool {
#if DEBUG
        // MARK: - disable fasting limits in Debug version
        false
#else
        appCustomization.fastingLimitCycles <= cyclesCount
#endif
    }

    func increaseLimit(by count: Int) {
        cyclesCount += count
    }

    private var cyclesCount: Int {
        get { cloudStorage.get(key: fastingFinishedCyclesLimitKey, defaultValue: 0)}
        set { cloudStorage.set(key: fastingFinishedCyclesLimitKey, value: newValue)}
    }
}
