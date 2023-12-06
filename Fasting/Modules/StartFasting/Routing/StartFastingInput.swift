//  
//  StartFastingInput.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioUI

struct StartFastingInput {
    enum Context: String {
        case fastingScreen
        case endFasting
    }

    enum Kind {
        case startTime
        case endTime
    }
    let title: LocalizedStringKey
    let datePickerComponents: DatePickerComponents
    let initialDate: Date
    let datesRange: ClosedRange<Date>
    let context: Context
    let kind: Kind
}

extension StartFastingInput {
    static func startFasting(context: Context,
                             isActiveState: Bool,
                             initialDate: Date,
                             minDate: Date,
                             maxDate: Date,
                             components: DatePickerComponents) -> StartFastingInput {
        .init(title: isActiveState ? "StartFastingScreen.whenToStart" : "StartFastingScreen.whenWantToStart",
              datePickerComponents: components,
              initialDate: initialDate,
              datesRange: minDate ... maxDate,
              context: context,
              kind: .startTime)
    }

    static func endFasting(initialDate: Date, minDate: Date) -> StartFastingInput {
        .init(title: "StartFastingScreen.whenFinished",
              datePickerComponents: [.date, .hourAndMinute],
              initialDate: initialDate,
              datesRange: minDate ... .now,
              context: .endFasting,
              kind: .endTime
        )
    }
}
