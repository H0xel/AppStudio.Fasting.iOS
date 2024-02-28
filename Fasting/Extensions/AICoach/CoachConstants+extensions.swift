//
//  CoachConstants+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 19.02.2024.
//

import Foundation
import AICoach

extension CoachConstants {
    static var fastingConstants: CoachConstants {
        .init(privacyPolicy: GlobalConstants.privacyPolicy,
              termsOfUse: GlobalConstants.termsOfUse,
              appName: "CoachConstants.appName".localized())
    }
}
