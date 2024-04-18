//  
//  RateAppInput.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//
import SwiftUI

public struct RateAppInput {
    let image: Image
    let title: String
    let placeholder: String
    let buttonTitle: String

    public init(image: Image, title: String, placeholder: String, buttonTitle: String) {
        self.image = image
        self.title = title
        self.placeholder = placeholder
        self.buttonTitle = buttonTitle
    }
}

public extension RateAppInput {
    static var calorieCounter: RateAppInput {
        .init(
            image: .rateIllustration,
            title: "RateAppInput.calorieCounter.title".localized(bundle: .module),
            placeholder: "RateAppInput.calorieCounter.placeholder".localized(bundle: .module),
            buttonTitle: "RateAppInput.calorieCounter.buttonTitle".localized(bundle: .module)
        )
    }
}
