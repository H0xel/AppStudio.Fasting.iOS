//
//  VerticalDashedGridModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 27.03.2024.
//

import SwiftUI
import Charts

public struct VerticalDashedGridModifier: ViewModifier {

    public init() {}

    public func body(content: Content) -> some View {
        content
            .chartXAxis {
                AxisMarks(preset: .aligned,
                          position: .bottom,
                          values: .stride(by: .day)) { value in
                    AxisGridLine(stroke: .init(lineWidth: .lineWidth,
                                               lineCap: .square,
                                               dash: [4, 4]))
                    .foregroundStyle(Color.studioGreyStrokeFill)
                    AxisValueLabel(format: .dateTime.weekday())
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
        .modifier(VerticalDashedGridModifier())
}
