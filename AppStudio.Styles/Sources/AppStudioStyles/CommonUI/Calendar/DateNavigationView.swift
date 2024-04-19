//
//  HealthOverviewNavigationView.swift
//
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI

public struct DateNavigationView: View {

    @Binding private var date: Date
    private let dateFormat: String
    private let foregroundColor: Color
    private let isFutureAllowed: Bool
    private let onPrevDayTap: (Date) -> Void
    private let onNextDayTap: (Date) -> Void

    public init(date: Binding<Date>,
                foregroundColor: Color = .studioBlackLight,
                dateFormat: String = "MMMdd",
                isFutureAllowed: Bool = false,
                onPrevDayTap: @escaping (Date) -> Void,
                onNextDayTap: @escaping (Date) -> Void) {
        self._date = date
        self.foregroundColor = foregroundColor
        self.dateFormat = dateFormat
        self.isFutureAllowed = isFutureAllowed
        self.onPrevDayTap = onPrevDayTap
        self.onNextDayTap = onNextDayTap
    }

    public var body: some View {
        HStack(spacing: .spacing) {
            Button {
                date = date.adding(.day, value: -1)
                onPrevDayTap(date)
            } label: {
                Image.chevronLeft
                    .frame(width: .buttonWidth, height: .buttonWidth)
            }
            Button {
                date = .now.startOfTheDay
            } label: {
                Text(date.localeDateOrTodayOrYesterday(with: dateFormat))
                    .font(.poppins(.buttonText))
            }
            Button {
                if isFutureAllowed || !isToday {
                    date = date.adding(.day, value: 1)
                    onNextDayTap(date)
                }
            } label: {
                Image.chevronRight
                    .foregroundStyle(rightButtonColor)
                    .frame(width: .buttonWidth, height: .buttonWidth)
            }
        }
        .foregroundStyle(foregroundColor)
    }

    private var rightButtonColor: Color {
        isFutureAllowed || !isToday ? foregroundColor : .studioGreyStrokeFill
    }

    private var isToday: Bool {
        date == .now.startOfTheDay
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 20
    static let buttonWidth: CGFloat = 24
}

#Preview {
    DateNavigationView(date: .constant(.now.startOfTheDay),
                       dateFormat: "MMMdd",
                       onPrevDayTap: { _ in },
                       onNextDayTap: { _ in })
}
