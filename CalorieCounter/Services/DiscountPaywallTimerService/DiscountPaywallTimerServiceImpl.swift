//  
//  DiscountPaywallTimerServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 08.02.2024.
//

import Foundation
import MunicornFoundation
import Dependencies
import Combine

class DiscountPaywallTimerServiceImpl: DiscountPaywallTimerService {
    @Dependency(\.storageService) private var storageService
    private var discountAvailableTrigger = CurrentValueSubject<DiscountPaywallInfo?, Never>(nil)

    var discountAvailable: AnyPublisher<DiscountPaywallInfo?, Never> {
        discountAvailableTrigger.eraseToAnyPublisher()
    }

    func setAvailableDiscount(data: DiscountPaywallInfo?) {
        discountAvailableTrigger.send(data)
    }


    func registerPaywall(info: DiscountPaywallInfo) {

        if storageService.startTimerTime == nil {

            storageService.startTimerTime = .now
            storageService.endPaywallTime = .now.addingTimeInterval(.init(seconds: info.timerDurationInSeconds ?? 0))

            if let reloadTime = info.renewOfferTime {

                let reloadTimeDate = Date.init(timeInterval: .init(hours: reloadTime), since: .now)

                if storageService.reloadTimerTime == nil {
                    storageService.reloadTimerTime = reloadTimeDate
                }
            }
        }

        checkPaywallAvailable(info: info)
    }

    private func checkPaywallAvailable(info: DiscountPaywallInfo) {
        let paywallIsEnded = paywallTimerEnded(info: info)
        let needToReloadPaywall = needToReloadPaywall(info: info)

        if paywallIsEnded {
            setAvailableDiscount(data: needToReloadPaywall ? info : nil)
            return
        }

        setAvailableDiscount(data: info)
    }


    func getCurrentTimer(durationInSeconds: Int) -> TimeInterval? {
        guard let startTimerDate = storageService.startTimerTime else {
            return nil
        }
        let startTimerDateWithDuration = startTimerDate.addingTimeInterval(.init(seconds: durationInSeconds))
        return startTimerDateWithDuration.timeIntervalSinceNow
    }

    func reset() {
        storageService.startTimerTime = nil
        storageService.reloadTimerTime = nil
        storageService.endPaywallTime = nil
        storageService.timerIsFinished = false
    }

    func stopTimer() {
        discountAvailableTrigger.send(nil)
        storageService.endPaywallTime = .now
    }

    private func needToReloadPaywall(info: DiscountPaywallInfo) -> Bool {
        if let reloadTimerDate = storageService.reloadTimerTime, let reloadDuration = info.renewOfferTime {
            if Date.now > reloadTimerDate {
                let reloadTimeDate = Date.init(timeInterval: .init(hours: reloadDuration), since: .now)
                storageService.reloadTimerTime = reloadTimeDate
                storageService.startTimerTime = .now
                storageService.endPaywallTime = .now.addingTimeInterval(
                    .init(seconds: info.timerDurationInSeconds ?? 0)
                )
                storageService.timerIsFinished = false
                return true
            }

            return false
        }

        return false
    }

    private func paywallTimerEnded(info: DiscountPaywallInfo) -> Bool {
        if let endPaywallTime = storageService.endPaywallTime {
            if Date.now > endPaywallTime {
                storageService.timerIsFinished = true
                return true
            }
        }
        return false
    }
}

private let startTimerTimeKey = "CalorieCounter.startTimerTimeKey"
private let reloadTimerTimeKey = "CalorieCounter.reloadTimerTimeKey"
private let endPaywallTimeKey = "CalorieCounter.endPaywallTimeKey"
private let timerIsFinishedKey = "CalorieCounter.timerIsFinishedKey"

extension StorageService {
    var startTimerTime: Date? {
        get { get(key: startTimerTimeKey) }
        set { set(key: startTimerTimeKey, value: newValue) }
    }

    var endPaywallTime: Date? {
        get { get(key: endPaywallTimeKey) }
        set { set(key: endPaywallTimeKey, value: newValue) }
    }

    var reloadTimerTime: Date? {
        get { get(key: reloadTimerTimeKey) }
        set { set(key: reloadTimerTimeKey, value: newValue) }
    }

    var timerIsFinished: Bool {
        get { get(key: timerIsFinishedKey, defaultValue: false) }
        set { set(key: timerIsFinishedKey, value: newValue) }
    }
}
