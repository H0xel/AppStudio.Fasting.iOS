//  
//  StartFastingInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioUI

struct StartFastingInput {
    let title: LocalizedStringKey
    let datePickerComponents: DatePickerComponents
    let initialDate: Date
    let datesRange: ClosedRange<Date>
}

extension StartFastingInput {
    static func startFasting(isActiveState: Bool,
                             initialDate: Date,
                             minDate: Date,
                             maxDate: Date,
                             components: DatePickerComponents) -> StartFastingInput {
        .init(title: isActiveState ? "StartFastingScreen.whenToStart" : "StartFastingScreen.whenWantToStart",
              datePickerComponents: components,
              initialDate: initialDate,
              datesRange: minDate ... maxDate)
    }

    static func endFasting(initialDate: Date, minDate: Date) -> StartFastingInput {
        .init(title: "StartFastingScreen.whenFinished",
              datePickerComponents: [.date, .hourAndMinute],
              initialDate: initialDate,
              datesRange: minDate ... .now)
    }
}
