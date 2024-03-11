//
//  FastingFinishedCyclesLimitServiceImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 24.11.2023.
//

import Dependencies

private let fastingFinishedCyclesLimitKey = "Fasting.fastingFinishedCyclesLimitKey"
private let fastingFinishedCyclesLimitCount = 2

class FastingFinishedCyclesLimitServiceImpl: FastingLimitService {
    @Dependency(\.cloudStorage) private var cloudStorage

    var isLimited: Bool {
#if DEBUG
        // MARK: - disable fasting limits in Debug version
        true
#else
        fastingFinishedCyclesLimitCount <= cyclesCount
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
