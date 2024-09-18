//
//  OnboardingData.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import Foundation
import AppStudioModels

struct OnboardingData: Codable {
    var createdDate: Date = .now
    var birthDay: Date
    var lastPeriodDate: Date

    var currentWeight: CGFloat
    var currentWeightUnit: WeightUnit

    var periodDurationDays: Int
    var menstrualCycleDurationDays: Int
    var cyclePeriod: CyclePeriod?
    var useOfBirthControl: BirthControl?
    var fertilityGoals: [FertilityGoal]
    var topics: [Topic]
    var features: [Feature]
}

extension OnboardingData {
    static var initial: OnboardingData {
        .init(birthDay: .now,
              lastPeriodDate: .now,
              currentWeight: 0,
              currentWeightUnit: .lb,
              periodDurationDays: 0,
              menstrualCycleDurationDays: 0,
              cyclePeriod: nil,
              useOfBirthControl: nil,
              fertilityGoals: [],
              topics: [],
              features: [])
    }
}

enum CyclePeriod: String, CaseIterable, OnboardingPickerOption, Codable {
    case regular
    case irregular

    var title: String {
        "Onboarding.lastPeriod.menstrualPeriod.\(rawValue).title".localized()
    }

    var description: String? {
        "Onboarding.lastPeriod.menstrualPeriod.\(rawValue).subtitle".localized()
    }

    var isFt: Bool { false }

    var isRecommended: Bool { false }

    var id: String { rawValue }
}

enum BirthControl: String, CaseIterable, OnboardingPickerOption, Codable {
    case yes
    case no

    var title: String { "Onboarding.lastPeriod.menstrualPeriod.pharmacy.\(rawValue)".localized() }

    var description: String? { nil }

    var isFt: Bool { false }

    var isRecommended: Bool { false }

    var id: String { rawValue }
}

enum FertilityGoal: String, CaseIterable, OnboardingPickerOption, Codable {
    case tryingToConceive
    case avoidingPregnancy
    case trackingForHealth
    case notSureYet

    var title: String {"Onboarding.lastPeriod.fertilityGoals.\(rawValue)".localized() }

    var description: String? { nil }

    var isFt: Bool { false }

    var isRecommended: Bool { false }

    var id: String { rawValue }
}

enum Topic: String, CaseIterable, OnboardingPickerOption, Codable {
    case reproductiveHealth
    case mentalWellBeing
    case nutritionAndLifestyle
    case productReviews
    case personalStoriesAndExperiences

    var title: String {"Onboarding.topics.\(rawValue)".localized() }

    var description: String? { nil }

    var isFt: Bool { false }

    var isRecommended: Bool { false }

    var id: String { rawValue }
}

enum Feature: String, CaseIterable, OnboardingPickerOption, Codable {
    case accuratePeriodTracking
    case ovulationAndFertilityTracking
    case symptomTracking
    case healthInsightsAndRecommendations

    var title: String {"Onboarding.features.\(rawValue)".localized() }

    var description: String? { nil }

    var isFt: Bool { false }

    var isRecommended: Bool { false }

    var id: String { rawValue }
}
