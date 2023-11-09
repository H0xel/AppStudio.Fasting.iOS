//
//  FastingPlan.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import SwiftUI

enum FastingPlan: Int, CaseIterable {
    case regular = 0
    case beginner
    case expert

    var duration: TimeInterval {
        switch self {
        case .regular:
            return .hour * 16
        case .beginner:
            return .hour * 14
        case .expert:
            return .hour * 20
        }
    }

    var backgroundColor: Color {
        switch self {
        case .regular:
            return .fastingBlue
        case .beginner:
            return .fastingGreen
        case .expert:
            return .fastingPurple
        }
    }

    var descriptionBackgroundColor: Color {
        switch self {
        case .regular:
            return .fastingBlueDark
        case .beginner:
            return .fastingGreenDark
        case .expert:
            return .fastingPurpleDark
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .regular:
            return LocalizedStringKey("ChooseFastingPlan.regular")
        case .beginner:
            return LocalizedStringKey("ChooseFastingPlan.beginner")
        case .expert:
            return LocalizedStringKey("ChooseFastingPlan.expert")
        }
    }

    var fastingDescription: LocalizedStringKey {
        switch self {
        case .regular:
            return LocalizedStringKey("ChooseFastingPlan.regular.description")
        case .beginner:
            return LocalizedStringKey("ChooseFastingPlan.beginner.description")
        case .expert:
            return LocalizedStringKey("ChooseFastingPlan.expert.description")
        }
    }

    var intervalPlan: LocalizedStringKey {
        switch self {
        case .regular:
            return LocalizedStringKey("ChooseFastingPlan.regular.intervalPlan")
        case .beginner:
            return LocalizedStringKey("ChooseFastingPlan.beginner.intervalPlan")
        case .expert:
            return LocalizedStringKey("ChooseFastingPlan.expert.intervalPlan")
        }
    }

    var intervalDescription: LocalizedStringKey {
        switch self {
        case .regular:
            return LocalizedStringKey("ChooseFastingPlan.regular.intervalDescription")
        case .beginner:
            return LocalizedStringKey("ChooseFastingPlan.beginner.intervalDescription")
        case .expert:
            return LocalizedStringKey("ChooseFastingPlan.expert.intervalDescription")
        }
    }

    var maskImage: Image {
        switch self {
        case .regular:
            return Image(.fastingPlanMask168)
        case .beginner:
            return Image(.fastingPlanMask1410)
        case .expert:
            return Image(.fastingPlanMask2042)
        }
    }

    var description: String {
        switch self {
        case .regular:
            return "16:8"
        case .beginner:
            return "14:10"
        case .expert:
            return "20:4"
        }
    }
}

extension FastingPlan: Equatable {}
