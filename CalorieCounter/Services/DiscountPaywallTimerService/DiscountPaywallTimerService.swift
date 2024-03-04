//  
//  DiscountPaywallTimerService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 08.02.2024.
//

import Foundation
import Combine

protocol DiscountPaywallTimerService {
    var discountAvailable: AnyPublisher<DiscountPaywallInfo?, Never> { get }

    func setAvailableDiscount(data: DiscountPaywallInfo?)

    func getCurrentTimer(durationInSeconds: Int) -> TimeInterval?

    func registerPaywall(info: DiscountPaywallInfo)

    func reset()

    func stopTimer()
}
