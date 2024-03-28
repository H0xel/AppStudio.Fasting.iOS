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
    private let onPrevDayTap: (Date) -> Void
    private let onNextDayTap: (Date) -> Void

    public init(date: Binding<Date>,
                dateFormat: String,
                onPrevDayTap: @escaping (Date) -> Void,
                onNextDayTap: @escaping (Date) -> Void) {
        self._date = date
        self.dateFormat = dateFormat
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
            }
            Text(date.localeDateOrTodayOrYesterday(with: dateFormat))
                .font(.poppins(.buttonText))
            Button {
                if !isToday {
                    date = date.adding(.day, value: 1)
                    onNextDayTap(date)
                }
            } label: {
                Image.chevronRight
                    .foregroundStyle(rightButtonColor)
            }
        }
        .foregroundStyle(Color.studioBlackLight)
    }

    private var rightButtonColor: Color {
        isToday ? .studioGreyStrokeFill : Color.studioBlackLight
    }

    private var isToday: Bool {
        date == .now.beginningOfDay
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 20
}

#Preview {
    DateNavigationView(date: .constant(.now.beginningOfDay),
                       dateFormat: "MMMdd",
                       onPrevDayTap: { _ in },
                       onNextDayTap: { _ in })
}
