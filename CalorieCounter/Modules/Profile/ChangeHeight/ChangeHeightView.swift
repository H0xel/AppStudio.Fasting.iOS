//
//  ChangeHeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.01.2024.
//

import SwiftUI

struct ChangeHeightView: View {

    let initialHeight: HeightMeasure
    let onBackTap: () -> Void
    let onSaveTap: (HeightMeasure) -> Void
    @State private var currentHeight: CGFloat = 0
    @State private var inchValue: CGFloat = 0
    @State private var heightUnit: HeightUnit = .cm

    var body: some View {
        ZStack {
            OnboardingSegmentedView(title: .heightTitle,
                                    description: nil,
                                    value: $currentHeight,
                                    inchValue: $inchValue,
                                    currentSegment: $heightUnit,
                                    segments: HeightUnit.allCases)
            ProfileChangeView(isSaveButtonEnabled: isSaveButtonEnable) {
                onSaveTap(currentHeightMeasure)
            }
            .aligned(.bottom)
        }
        .onAppear {
            configure()
        }
        .navBarButton(content: Image.chevronLeft.foregroundStyle(.accent),
                      action: onBackTap)
    }

    private func configure() {
        heightUnit = initialHeight.units
        switch heightUnit {
        case .ft:
            let feets = initialHeight.feets
            currentHeight = CGFloat(feets.feets)
            inchValue = CGFloat(feets.inches)
        case .cm:
            currentHeight = initialHeight.normalizeValue
        }
    }

    private var currentHeightMeasure: HeightMeasure {
        heightUnit == .cm ? .init(centimeters: currentHeight) : .init(feet: currentHeight, inches: inchValue)
    }

    private var isSaveButtonEnable: Bool {
        (initialHeight.normalizeValue != currentHeightMeasure.normalizeValue ||
         initialHeight.units != currentHeightMeasure.units) &&
        currentHeight > 0
    }
}

private extension String {
    static let heightTitle = NSLocalizedString("Onboarding.height.title", comment: "")
}

#Preview {
    ChangeHeightView(initialHeight: .init(centimeters: 184), onBackTap: {}, onSaveTap: { _ in })
}
