//  
//  RateAppService.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

protocol RateAppService {
    func canShowRateAppWindow() async throws -> Bool
    func rateAppWindowShown()

    var canShowAppStoreReviewDialog: Bool { get }
    func canShowRateUsDialog() async throws -> Bool
    func rateUsDialogShown()
    func userRatedUs()
}
