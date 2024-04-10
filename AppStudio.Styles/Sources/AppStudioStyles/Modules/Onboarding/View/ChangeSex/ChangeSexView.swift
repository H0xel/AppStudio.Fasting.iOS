//
//  ChangeSexView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioModels

struct ChangeSexView: View {

    let initialSex: Sex
    let showDescription: Bool
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
            ProfileChangeView(showDescription: showDescription,
                              isSaveButtonEnabled: currentSex != initialSex) {
                onSaveTap(currentSex)
            }
        }
        .onAppear {
            currentSex = initialSex
        }
        .navBarButton(content: Image.chevronLeft.foregroundStyle(Color.studioBlackLight),
                      action: onBackTap)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 32
    static let horizontalPadding: CGFloat = 32
}

private extension String {
    static let sexTitle = "Onboarding.sex.title".localized(bundle: .module)
    static let sexDescription = "Onboarding.sex.description".localized(bundle: .module)
}

#Preview {
    ChangeSexView(initialSex: .male,
                  showDescription: true,
                  onBackTap: {},
                  onSaveTap: { _ in })
}

