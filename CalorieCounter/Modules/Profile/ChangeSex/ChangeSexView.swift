//
//  ChangeSexView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI

struct ChangeSexView: View {

    let initialSex: Sex
    let onBackTap: () -> Void
    let onSaveTap: (Sex) -> Void
    @State private var currentSex: Sex = .female

    var body: some View {
        VStack(spacing: .spacing) {
            OnboardingPickerView(title: .sexTitle,
                                 description: .sexDescription,
                                 options: Sex.allCases,
                                 selectedOptions: [currentSex],
                                 bottomPadding: 0) { sex in
                currentSex = sex
            }
            .scrollDisabled(true)
            .padding(.horizontal, .horizontalPadding)
            ProfileChangeView(isSaveButtonEnabled: currentSex != initialSex) {
                onSaveTap(currentSex)
            }
        }
        .onAppear {
            currentSex = initialSex
        }
        .navBarButton(content: Image.chevronLeft.foregroundStyle(.accent),
                      action: onBackTap)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 32
    static let horizontalPadding: CGFloat = 32
}

private extension String {
    static let sexTitle = NSLocalizedString("Onboarding.sex.title", comment: "")
    static let sexDescription = NSLocalizedString("Onboarding.sex.description", comment: "")
}

#Preview {
    ChangeSexView(initialSex: .male, onBackTap: {}, onSaveTap: { _ in })
}
