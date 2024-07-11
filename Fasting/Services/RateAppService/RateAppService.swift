//  
//  RateAppService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 09.07.2024.
//

protocol RateAppService {
    var canShowAppStoreReviewDialog: Bool { get }
    func canShowRateUsDialog() async throws -> Bool
    func rateUsDialogShown()
    func userRatedUs()
}
