//
//  CoachConstants.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.04.2024.
//

import Foundation
import AICoach

extension CoachConstants {
    static var counterConstants: CoachConstants {
        .init(privacyPolicy: GlobalConstants.privacyPolicy,
              termsOfUse: GlobalConstants.termsOfUse,
              appName: "CoachConstants.appName".localized())
    }
}
