//
//  OnboardingPickerOption.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import Foundation

protocol OnboardingPickerOption: Identifiable, Hashable {
    var title: String { get }
    var description: String? { get }
    var isFt: Bool { get }
}

extension FastingGoal: OnboardingPickerOption {
    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}

extension Sex: OnboardingPickerOption {
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

extension HeightUnit: OnboardingPickerOption {
    var id: String {
        rawValue
    }

    var description: String? {
        nil
    }

    var isFt: Bool {
        return self == .ft
    }
}

extension WeightUnit: OnboardingPickerOption {
    var id: String {
        rawValue
    }

    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}

extension ExerciseActivity: OnboardingPickerOption {
    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}

extension ActivityType: OnboardingPickerOption {
    var description: String? {
        nil
    }

    var isFt: Bool {
        false
    }
}

extension CalorieGoal: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }

    var isFt: Bool {
        false
    }
}

extension DietType: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }

    var isFt: Bool {
        false
    }
}

extension ProteinLevel: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }

    var isFt: Bool {
        false
    }
}
