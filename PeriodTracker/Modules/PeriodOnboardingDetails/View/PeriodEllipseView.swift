//
//  PeriodEllipseView.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import SwiftUI

struct PeriodEllipseView: View {
    let kind: Kind

    var body: some View {
        Ellipse()
            .fill(kind.backgroundColor)
            .frame(width: .elipseWidth, height: .elipseHeight)
    }
}

extension PeriodEllipseView {
    enum Kind {
        case cycleStarted
        case nothing
        case ovulation
        case preOvulation

        var backgroundColor: Color {
            switch self {
            case .cycleStarted:
                return Color.studioRed
            case .nothing:
                return Color.studioGreyFillIcon
            case .ovulation:
                return Color.studioBlueLight
            case .preOvulation:
                return Color.studioBlueLight.opacity(0.5)
            }
        }
    }
}

private extension CGFloat {
    static let elipseWidth: CGFloat = (UIScreen.main.bounds.width - 168) / 31
    static let elipseHeight: CGFloat = 16
}

#Preview {
    PeriodEllipseView(kind: .cycleStarted)
}
