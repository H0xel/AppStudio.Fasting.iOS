//
//  CoachStyles+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 19.02.2024.
//

import Foundation
import AICoach
import AppStudioStyles

extension CoachStyles {
    static var fastingStyles: CoachStyles {
        .init(fonts: .init(body: .poppins(.body),
                           buttonText: .poppins(.buttonText),
                           description: .poppins(.description)),
              colors: .init(accent: .accent,
                            coachGreyStrokeFill: .studioGreyStrokeFill,
                            coachGrayFillProgress: .studioGrayFillProgress,
                            userMessage: .studioUserMessage,
                            coachGrayFillCard: .studioGrayFillCard,
                            coachGrayPlaceholder: .studioGrayPlaceholder,
                            coachGrayText: .studioGrayText,
                            coachSky: .studioSky),
              images: .init(coachIcon: .coachIcon))
    }
}
