//
//  CalendarStyle.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI
import AppStudioModels

public struct CalendarStyle {

    public enum StrokeColor {
        case color(Color)
        case gradient((DayProgress) -> [Color])
    }

    let letterColor: Color
    let numberColor: Color
    let dotColor: Color
    let selectedDayBackgroundColor: Color
    let selectedDayTextColor: Color
    let strokeColor: StrokeColor
    let dotWidth: CGFloat

    public init(letterColor: Color,
                numberColor: Color,
                dotColor: Color,
                dotWidth: CGFloat,
                selectedDayBackgroundColor: Color,
                selectedDayTextColor: Color,
                strokeColor: StrokeColor) {
        self.letterColor = letterColor
        self.numberColor = numberColor
        self.dotColor = dotColor
        self.selectedDayBackgroundColor = selectedDayBackgroundColor
        self.selectedDayTextColor = selectedDayTextColor
        self.strokeColor = strokeColor
        self.dotWidth = dotWidth
    }
}

public extension CalendarStyle {
    static var updateWeight: CalendarStyle {
        .init(letterColor: .studioGreyPlaceholder,
              numberColor: .studioBlackLight,
              dotColor: .studioBlackLight, 
              dotWidth: 4,
              selectedDayBackgroundColor: .studioGrayFillProgress,
              selectedDayTextColor: .studioBlackLight,
              strokeColor: .color(.studioGreyStrokeFill))
    }

    static var fastingHealthOverview: CalendarStyle {
        let colors = CalendarStyle.StrokeColor.gradient { progress in
            var colors: [Color] =  [.studioBlue]

            let result = progress.result

            if result > 2 {
                colors.append(.studioPurple)
            }
            if result > 8 {
                colors.append(.studioRed)
            }
            if result > 10 {
                colors.append(.studioOrange)
            }
            if result > 14 {
                colors.append(.studioGreen)
            }
            if result > 16 {
                colors.append(.studioSky)
            }
            return colors
        }
        return .init(letterColor: .studioGreyPlaceholder,
                     numberColor: .studioBlackLight,
                     dotColor: .studioBlackLight, 
                     dotWidth: 6,
                     selectedDayBackgroundColor: .studioGrayFillProgress,
                     selectedDayTextColor: .studioBlackLight,
                     strokeColor: colors)
    }

    static var calorieCounter: CalendarStyle {
        .init(letterColor: .white,
              numberColor: .white,
              dotColor: .white,
              dotWidth: 6,
              selectedDayBackgroundColor: .studioBlackLight.opacity(0.15),
              selectedDayTextColor: .white,
              strokeColor: .color(.white))
    }
}
