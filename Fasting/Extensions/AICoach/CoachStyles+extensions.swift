//
//  CoachStyles+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 19.02.2024.
//

import Foundation
import AICoach

extension CoachStyles {
    static var fastingStyles: CoachStyles {
        .init(fonts: .init(body: .poppins(.body),
                           buttonText: .poppins(.buttonText),
                           description: .poppins(.description)),
              colors: .init(accent: .accent,
                            coachGreyStrokeFill: .fastingGreyStrokeFill,
                            coachGrayFillProgress: .fastingGrayFillProgress,
                            userMessage: .userMessage,
                            coachGrayFillCard: .fastingGrayFillCard,
                            coachGrayPlaceholder: .fastingGrayPlaceholder,
                            coachGrayText: .fastingGrayText, 
                            coachSky: .fastingSky),
              images: .init(coachIcon: .init(.coachIcon)))
    }
}
