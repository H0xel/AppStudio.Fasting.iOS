//
//  MealWeightView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.12.2023.
//

import SwiftUI
import AppStudioStyles

struct MealWeightView: View {

    @Binding var isTextSelected: Bool
    let type: MealWeightType
    let serving: MealServing
    let isTapped: Bool
    let withoutDecimalIfNeeded: Bool
    let weightColor: Color
    let width: CGFloat
    let onTap: () -> Void

    init(isTextSelected: Binding<Bool>,
         type: MealWeightType,
         serving: MealServing,
         isTapped: Bool,
         withoutDecimalIfNeeded: Bool = false,
         weightColor: Color = Color.studioBlackLight,
         width: CGFloat = .width,
         onTap: @escaping () -> Void) {
        self._isTextSelected = isTextSelected
        self.type = type
        self.serving = serving
        self.withoutDecimalIfNeeded = withoutDecimalIfNeeded
        self.weightColor = weightColor
        self.isTapped = isTapped
        self.width = width
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: .spacing) {
            TextWithCursorView(isTextSelected: $isTextSelected, text: weight, isFocused: isTapped)
                .layoutPriority(1)
            Text(servingTitle)
                .foregroundStyle(Color.studioGreyText)
        }
        .padding(.horizontal, .horizontalPadding)
        .font(.poppins(.description))
        .frame(width: width, height: .height)
        .background(Color.studioGreyFillProgress)
        .continiousCornerRadius(.cornerRadius)
        .border(configuration: .init(
            cornerRadius: .cornerRadius,
            color: .accent,
            lineWidth: isTapped ? .borderWidth : 0)
        )
        .onTapGesture {
            if isTextSelected {
                isTextSelected = false
                return
            }
            onTap()
            isTextSelected = true
        }
    }

    private var servingTitle: String {
        switch type {
        case .text(let text):
            serving.units(for: Double(text) ?? 1)
        case .weight(let weight):
            serving.units(for: weight)
        }
    }

    private var weight: String {
        switch type {
        case .text(let text):
            text
        case .weight(let weight):
            convertedWeight(weight: weight)
        }
    }

    private func convertedWeight(weight: Double) -> String {
        if withoutDecimalIfNeeded {
            return weight.withoutDecimalsIfNeeded
        }
        return serving == .gramms
        ? "\(String(format: "%.0f", weight))"
        : weight.withoutDecimalsIfNeeded
    }
}

extension MealWeightView {
    enum MealWeightType {
        case text(String)
        case weight(Double)
    }
}

private extension CGFloat {
    static let width: CGFloat = 80
    static let height: CGFloat = 32
    static let cornerRadius: CGFloat = 8
    static let spacing: CGFloat = 4
    static let borderWidth: CGFloat = 2
    static let horizontalPadding: CGFloat = 6
}

private extension MealWeightView {
    enum Localization {
        static let gram: LocalizedStringKey = "Ingredient.weightLabel"
    }
}

#Preview {
    MealWeightView(isTextSelected: .constant(true), type: .weight(24), serving: .gramms, isTapped: true) {}
}
