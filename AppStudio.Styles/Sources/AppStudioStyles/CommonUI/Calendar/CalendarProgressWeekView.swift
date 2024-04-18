//
//  CalendarProgressWeekView.swift
//
//
//  Created by Руслан Сафаргалеев on 07.03.2024.
//
//
import SwiftUI
import AppStudioUI
import AppStudioFoundation

struct CalendarProgressWeekView: View {

    let styles: CalendarStyle
    let selectedDate: Date
    let progress: [CalendarProgress]
    let isFutereAllowed: Bool
    let onTap: (Date) -> Void

    public var body: some View {
        LazyHStack {
            ForEach(progress, id: \.day) { progress in
                VStack(spacing: .zero) {
                    Spacer()
                    Text(progress.day.currentLocaleFormatted(with: "EEEEE").uppercased())
                        .font(.poppins(.description))
                        .foregroundStyle(foregroundColor(for: progress.day,
                                                         defaultColor: styles.letterColor))
                        .opacity(progress.day == selectedDate ? 1 : 0.7)
                        .frame(height: .letterHeight)
                        .padding(.bottom, .letterBottomPadding)
                    Text("\(progress.day.day)")
                        .font(.poppins(.body))
                        .foregroundStyle(foregroundColor(for: progress.day,
                                                         defaultColor: styles.numberColor))
                        .frame(height: .dayHeight)
                        .overlay {
                            Circle()
                                .fill(styles.dotColor)
                                .frame(width: styles.dotWidth)
                                .opacity(progress.day == .now.startOfTheDay ? 1 : 0)
                                .aligned(.bottom)
                                .offset(y: styles.dotWidth + .dayBottomPadding)
                        }
                    Spacer()
                }
                .frame(width: .dayWidth)
                .background {
                    if progress.day == selectedDate.startOfTheDay {
                        styles.selectedDayBackgroundColor
                    }
                }
                .overlay(
                    ZStack {
                        switch styles.strokeColor {
                        case .color(let color):
                            Capsule()
                                .trim(from: 0, to: progress.progress.result / progress.progress.goal)
                                .stroke(color, lineWidth: .colorBorderWidth)
                                .rotationEffect(.degrees(180))
                                .padding(.colorBorderWidth)
                        case .gradient(let colors):
                            Capsule()
                                .trim(from: 0, to: progress.progress.result / progress.progress.goal)
                                .stroke(LinearGradient(colors: colors(progress.progress),
                                                       startPoint: .leading,
                                                       endPoint: .trailing),
                                        lineWidth: .capsuleBorderWidth)
                                .rotationEffect(.degrees(180))
                                .padding(.capsuleBorderWidth)
                        }
                    }
                )
                .continiousCornerRadius(.cornerRadius)
                .onTapGesture {
                    onTap(progress.day)
                }

                if progress.day != self.progress.last?.day {
                    Spacer()
                }
            }
        }
    }

    private func foregroundColor(for date: Date,
                                 defaultColor: Color) -> Color {
        if date == selectedDate {
            return styles.selectedDayTextColor
        }
        if isFutereAllowed {
            return defaultColor
        }
        return date <= .now.startOfTheDay ? defaultColor : .studioGreyPlaceholder
    }
}

private extension CGFloat {
    static let cornerRadius: CGFloat = 56
    static let dayWidth: CGFloat = 44
    static let capsuleBorderWidth: CGFloat = 1.5
    static let colorBorderWidth: CGFloat = 0.5
    static let letterBottomPadding: CGFloat = 4
    static let letterHeight: CGFloat = 15
    static let dayHeight: CGFloat = 18
    static let dayBottomPadding: CGFloat = 2
}
