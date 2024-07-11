//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 09.07.2024.
//

import Foundation
import AppStudioUI

public extension RateUsInput {
    static func healthInput(reviewURL: String) -> RateUsInput {
        .init(
            title: "RateUsInput.title".localized(bundle: .module),
            tapToRate: "RateUsInput.tapToRate".localized(bundle: .module),
            badFeedbackTitle: "RateUsInput.badFeedbackTitle".localized(bundle: .module),
            badFeedbackDesription: "RateUsInput.badFeedbackDesription".localized(bundle: .module),
            badFeedbackButtonTitle: "RateUsInput.badFeedbackButtonTitle".localized(bundle: .module),
            goodFeedbackTitle: "RateUsInput.goodFeedbackTitle".localized(bundle: .module),
            goodFeedbackDesription: "RateUsInput.goodFeedbackDesription".localized(bundle: .module),
            goodFeedbackButtonTitle: "RateUsInput.goodFeedbackButtonTitle".localized(bundle: .module),
            buttonFont: .poppins(.buttonText),
            titleFont: .poppins(.headerM),
            reviewURL: URL(string: reviewURL)
        )
    }
}
