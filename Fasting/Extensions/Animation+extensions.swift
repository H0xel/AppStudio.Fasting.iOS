//
//  Animation+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 31.10.2023.
//

import SwiftUI

extension Animation {
    static var fastingStageChage: Animation {
        .easeInOut(duration: 0.25)
    }
}

extension View {
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
}
