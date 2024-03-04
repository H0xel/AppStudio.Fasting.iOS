//
//  BorderedNutritionModifier.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI

struct BorderedNutritionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, .horizontalPadding)
            .padding(.vertical, .verticalPadding)
            .border(configuration: .init(cornerRadius: .cornerRadius,
                                         color: .studioGreyStrokeFill,
                                         lineWidth: .borderWidth))
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 3
    static let horizontalPadding: CGFloat = 8
    static let borderWidth: CGFloat = 0.5
    static let cornerRadius: CGFloat = 28
}
