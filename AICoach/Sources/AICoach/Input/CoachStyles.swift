//
//  CoachStyles.swift
//  
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import SwiftUI

public struct CoachStyles {

    public struct Fonts {
        let body: Font
        let buttonText: Font
        let description: Font

        public init(body: Font, buttonText: Font, description: Font) {
            self.body = body
            self.buttonText = buttonText
            self.description = description
        }
    }
    public struct Colors {
        let accent: Color
        let coachGreyStrokeFill: Color
        let coachGrayFillProgress: Color
        let userMessage: Color
        let coachGrayFillCard: Color
        let coachGrayPlaceholder: Color
        let coachGrayText: Color
        let coachSky: Color

        public init(accent: Color,
                    coachGreyStrokeFill: Color,
                    coachGrayFillProgress: Color,
                    userMessage: Color,
                    coachGrayFillCard: Color,
                    coachGrayPlaceholder: Color,
                    coachGrayText: Color,
                    coachSky: Color) {
            self.accent = accent
            self.coachGreyStrokeFill = coachGreyStrokeFill
            self.coachGrayFillProgress = coachGrayFillProgress
            self.userMessage = userMessage
            self.coachGrayFillCard = coachGrayFillCard
            self.coachGrayPlaceholder = coachGrayPlaceholder
            self.coachGrayText = coachGrayText
            self.coachSky = coachSky
        }
    }

    public struct Images {
        let coachIcon: Image

        public init(coachIcon: Image) {
            self.coachIcon = coachIcon
        }
    }

    let fonts: Fonts
    let colors: Colors
    let images: Images

    public init(fonts: Fonts, colors: Colors, images: Images) {
        self.fonts = fonts
        self.colors = colors
        self.images = images
    }
}

public extension CoachStyles {
    static var mock: CoachStyles {
        .init(fonts: .init(body: .system(size: 15),
                           buttonText: .system(size: 18),
                           description: .system(size: 13)),
              colors: .init(accent: .black,
                            coachGreyStrokeFill: .secondarySystemFill,
                            coachGrayFillProgress: .gray,
                            userMessage: .blue,
                            coachGrayFillCard: .secondarySystemBackground,
                            coachGrayPlaceholder: .secondaryLabel,
                            coachGrayText: .init(uiColor: .lightGray), 
                            coachSky: .purple),
              images: .init(coachIcon: .init(systemName: "plus")))
    }
}
