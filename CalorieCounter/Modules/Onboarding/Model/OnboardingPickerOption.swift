//
//  OnboardingPickerOption.swift
//  CalorieCounter
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
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

    var isRecommended: Bool {
        switch self {
        case .balanced: return true
        default: return false
        }
    }
}

extension ProteinLevel: OnboardingPickerOption {
    var description: String? {
        descriptionTitle
    }

    var isFt: Bool {
        false
    }

    var isRecommended: Bool {
        switch self {
        case .moderate: return true
        default: return false
        }
    }
}
