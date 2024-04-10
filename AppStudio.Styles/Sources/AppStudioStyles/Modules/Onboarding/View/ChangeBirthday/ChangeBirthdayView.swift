//
//  ChangeBirthdayView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI

struct ChangeBirthdayView: View {

    let initialBirthday: Date
    let showDescription: Bool
    let onBackTap: () -> Void
    let onSave: (Date) -> Void

    @State private var currentBirthday: Date = .now

    var body: some View {
        ZStack {
            OnboardingDatePickerView(title: .birthdayTitle,
                                     canChoosePast: true,
                                     date: $currentBirthday)
            ProfileChangeView(showDescription: showDescription,
                              isSaveButtonEnabled: initialBirthday != currentBirthday) {
                onSave(currentBirthday)
            }
            .aligned(.bottom)
        }
        .onAppear {
            currentBirthday = initialBirthday
        }
        .navBarButton(content: Image.chevronLeft.foregroundStyle(Color.studioBlackLight),
                      action: onBackTap)
    }
}

private extension String {
    static let birthdayTitle = "Onboarding.birthdayTitle".localized(bundle: .module)
}

#Preview {
    ChangeBirthdayView(initialBirthday: .now,
                       showDescription: true,
                       onBackTap: {},
                       onSave: { _ in })
}

