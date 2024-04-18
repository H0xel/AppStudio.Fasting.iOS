//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import SwiftUI

enum BodyMassIndex: String, CaseIterable {
    case underweight
    case normal
    case overweight
    case obese

    var title: String {
        "BodyMassIndex.\(rawValue)".localized(bundle: .module)
    }

    var color: Color {
        switch self {
        case .underweight:
            return .studioBlue
        case .normal:
            return .studioGreen
        case .overweight:
            return .studioOrange
        case .obese:
            return .studioRed
        }
    }

    var maxValue: Double {
        switch self {
        case .underweight:
            return 18
        case .normal:
            return 25
        case .overweight:
            return 30
        case .obese:
            return 60
        }
    }

    var minValue: Double {
        switch self {
        case .underweight:
            return 10
        case .normal:
            return 18
        case .overweight:
            return 25
        case .obese:
            return 30
        }
    }

    var fullDescriptions: [String] {
        switch self {

        case .underweight:
            return [
                "HintTopic.bmi.bodyMassContent.underweight.topic1".localized(bundle: .module),
                "HintTopic.bmi.bodyMassContent.underweight.topic2".localized(bundle: .module)
            ]
        case .normal:
            return [
                "HintTopic.bmi.bodyMassContent.normal.topic1".localized(bundle: .module),
                "HintTopic.bmi.bodyMassContent.normal.topic2".localized(bundle: .module)
            ]
        case .overweight:
            return [
                "HintTopic.bmi.bodyMassContent.overweight.topic1".localized(bundle: .module),
                "HintTopic.bmi.bodyMassContent.overweight.topic2".localized(bundle: .module)
            ]
        case .obese:
            return [
                "HintTopic.bmi.bodyMassContent.obese.topic1".localized(bundle: .module),
                "HintTopic.bmi.bodyMassContent.obese.topic2".localized(bundle: .module)
            ]
        }
    }
}
