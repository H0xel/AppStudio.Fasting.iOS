//
//  AutomaticYAxisGridModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import Charts

public struct AutomaticYAxisGridModifier: ViewModifier {

    private let desiredCount: Int

    public init(desiredCount: Int) {
        self.desiredCount = desiredCount
    }

    public func body(content: Content) -> some View {
        content
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: desiredCount)) { _ in
                    AxisGridLine(stroke: .init(lineWidth: .lineWidth))
                        .foregroundStyle(Color.studioGreyStrokeFill)
                    AxisValueLabel()
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
    }
}

private extension CGFloat {
    static let lineWidth: CGFloat = 0.5
}

#Preview {
    Text("Hello, world!")
        .modifier(AutomaticYAxisGridModifier(desiredCount: 5))
}
