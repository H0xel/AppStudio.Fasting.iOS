//
//  OnboardingPickerOption.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import Foundation

protocol OnboardingPickerOption: Identifiable, Hashable {
    var title: String { get }
    var description: String? { get }
}

extension FastingGoal: OnboardingPickerOption {
    var description: String? {
        nil
    }
}

extension Sex: OnboardingPickerOption {
    var description: String? {
        nil
    }
}

extension ActivityLevel: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }
}

extension SpecialEvent: OnboardingPickerOption {
    var description: String? {
        nil
    }
}

extension HeightUnit: OnboardingPickerOption {
    var id: String {
        rawValue
    }

    var description: String? {
        nil
    }
}

extension WeightUnit: OnboardingPickerOption {
    var id: String {
        rawValue
    }

    var description: String? {
        nil
    }
}
