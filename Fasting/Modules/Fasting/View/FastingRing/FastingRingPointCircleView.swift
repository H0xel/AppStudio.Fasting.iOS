//
//  FastingRingPointCircleView.swift
//  Fasting
//
//  Created by Denis Khlopin on 28.11.2023.
//

import SwiftUI

struct FastingRingPointCircleView: View {
    let radius: CGFloat
    let point: FastingStagePoint

    var body: some View {
        ZStack {
            Circle().fill(fillColor)
            Circle().strokeBorder(strokeColor, lineWidth: strokeWidth)
            image
        }
        .scaleEffect(scaleFactor)
        .rotationEffect(Layout.rotationAngle)
    }

    private var scaleFactor: CGFloat {
        point.isSelected ? 1.1 : 1
    }

    private var image: Image {
        point.isSelected ? point.stage.whiteImage : point.stage.disabledImage
    }

    private var fillColor: Color {
        point.isSelected ? point.color : Color.white
    }

    private var strokeColor: Color {
        point.isSelected ? .white : .fastingGrayFillProgress
    }

    private var strokeWidth: CGFloat {
        point.isSelected ? 2 : 1
    }
}

private extension FastingRingPointCircleView {
    enum Layout {
        static let rotationAngle: Angle = .degrees(-90)
    }
}
