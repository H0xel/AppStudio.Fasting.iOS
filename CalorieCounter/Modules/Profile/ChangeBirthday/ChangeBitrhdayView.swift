//
//  ChangeBirthdayView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI

struct ChangeBirthdayView: View {

    let initialBirthday: Date
    let onBackTap: () -> Void
    let onSave: (Date) -> Void

    @State private var currentBirthday: Date = .now

    var body: some View {
        ZStack {
            OnboardingDatePickerView(title: .birthdayTitle,
                                     canChoosePast: true,
                                     date: $currentBirthday)
            ProfileChangeView(isSaveButtonEnabled: initialBirthday != currentBirthday) {
                onSave(currentBirthday)
            }
            .aligned(.bottom)
        }
        .onAppear {
            currentBirthday = initialBirthday
        }
        .navBarButton(content: Image.chevronLeft.foregroundStyle(.accent),
                      action: onBackTap)
    }
}

private extension String {
    static let birthdayTitle = NSLocalizedString("Onboarding.birthdayTitle", comment: "")
}

#Preview {
    ChangeBirthdayView(initialBirthday: .now,
                       onBackTap: {},
                       onSave: { _ in })
}
