//
//  FastingBackgroundModifier.swift
//  Fasting
//
//  Created by Amakhin Ivan on 01.11.2023.
//

import SwiftUI

struct FastingPlanBackgroundModifier: ViewModifier {
    let plan: FastingPlan

    func body(content: Content) -> some View {
        content
            .background(
                plan.backgroundColor
                    .overlay(
                        plan.maskImage
                            .resizable()
                            .scaledToFill()
                    )
            )
    }
}

extension View {
    func fastingPlanBackground(_ plan: FastingPlan) -> some View {
        modifier(FastingPlanBackgroundModifier(plan: plan))
    }
}
