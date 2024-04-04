//
//  DashedLine.swift
//
//
//  Created by Руслан Сафаргалеев on 01.04.2024.
//

import SwiftUI

public struct DashedLine: View {

    private let dashPattern: [CGFloat]
    private let lineWidth: CGFloat

    public init(dashPattern: [CGFloat] = [4, 4], lineWidth: CGFloat = 1) {
        self.dashPattern = dashPattern
        self.lineWidth = lineWidth
    }

    public var body: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: lineWidth, dash: dashPattern))
            .frame(height: lineWidth)
    }
}

#Preview {
    DashedLine()
}

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
