//
//  OnboardingPickerOption.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import Foundation
import AppStudioModels

extension FastingGoal: OnboardingPickerOption {
    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}

extension ActivityLevel: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }

    var isFt: Bool {
        false
    }
}

extension SpecialEvent: OnboardingPickerOption {
    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}
