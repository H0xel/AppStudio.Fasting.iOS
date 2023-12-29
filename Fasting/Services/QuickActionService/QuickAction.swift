//
//  QuickAction.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import UIKit

enum QuickAction: String {
    case review
}

extension QuickAction {
    var title: String {
        switch self {
        case .review:
            return Localization.title
        }
    }

    var subTitle: String {
        switch self {
        case .review:
            return Localization.subTitle
        }
    }

    var icon: UIApplicationShortcutIcon {
        switch self {
        case .review:
            return .init(systemImageName: "heart.fill")
        }
    }
}

private enum Localization {
    static let title = NSLocalizedString("Review.title", comment: "title")
    static let subTitle = NSLocalizedString("Review.subTitle", comment: "title")
}
