//
//  Sex.swift
//  Fasting
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation
import AppStudioAnalytics

enum Sex: String, CaseIterable, Identifiable, Codable {
    case male
    case female
    case other

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("Sex.\(rawValue)", comment: "")
    }

    var paywallTitle: String {
        switch self {
        case .male:
            NSLocalizedString("Sex.men", comment: "")
        case .female, .other:
            NSLocalizedString("Sex.women", comment: "")
        }
    }
}
