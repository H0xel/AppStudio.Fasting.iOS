//
//  FastingRingSettings.swift
//  Fasting
//
//  Created by Denis Khlopin on 28.11.2023.
//

import UIKit

struct FastingRingSettings {
    let radius: CGFloat
    let borderWidth: CGFloat
    let angleRange: ClosedRange<CGFloat>
    let trimRange: ClosedRange<CGFloat>

    var centerPoint: CGPoint {
        .init(x: 0, y: radius)
    }

    var totalWidth: CGFloat {
        radius * 2
    }
}

extension FastingRingSettings {
    static let `default` = FastingRingSettings(
        radius: UIScreen.isSmallDevice ? 130 : 160,
        borderWidth: 52,
        angleRange: 0.5 ... 5.8,
        trimRange: 0.08 ... 0.92
    )
}
