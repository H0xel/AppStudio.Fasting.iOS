//
//  MealVoting.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 15.04.2024.
//

import SwiftUI

enum MealVoting: Int16 {
    case notVoted = 0
    case like
    case dislike
    case disabled

    var buttonTitle: String {        
        switch self {
        case .notVoted:
            "MealVoting.title.notVoted".localized(bundle: .main)
        case .like:
            "MealVoting.title.like".localized(bundle: .main)
        case .dislike:
            "MealVoting.title.dislike".localized(bundle: .main)
        case .disabled:
            ""
        }
    }

    var imageThumbUp: Image {
        switch self {
        case .notVoted, .dislike:
                .thumbUp
        case .like:
                .thumbUpFilled
        case .disabled:
            .thumbUp
        }
    }

    var imageThumbDown: Image {
        switch self {
        case .notVoted, .like:
                .thumbDown
        case .dislike:
                .thumbDownFilled
        case .disabled:
                .thumbDown
        }
    }
}

