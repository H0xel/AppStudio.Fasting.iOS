//
//  SpecialEvent.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 06.12.2023.
//

import Foundation

enum SpecialEvent: String, CaseIterable, Identifiable, Codable {
    case vacation
    case wedding
    case sportsCompetition
    case summer
    case reunion
    case birthday
    case somethingElse
    case noSpecialEvent

    var id: String {
        rawValue
    }

    var title: String {
        NSLocalizedString("SpecialEvent.\(rawValue)", comment: "")
    }

    var eventName: String {
        switch self {
        case .somethingElse, .sportsCompetition:
            return NSLocalizedString("SpecialEvent.\(rawValue).title", comment: "")
        default:
            return title
        }
    }
}
