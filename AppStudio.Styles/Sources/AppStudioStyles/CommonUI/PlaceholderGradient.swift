//
//  PlaceholderGradient.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import SwiftUI

public struct PlaceholderGradient: View {

    private let currentLocation: CGFloat
    private let height: CGFloat

    public init(currentLocation: CGFloat, height: CGFloat = 36) {
        self.currentLocation = currentLocation
        self.height = height
    }

    public var body: some View {
        LinearGradient(stops: [
            .init(color: .studioGreyFillCard, location: -0.21),
            .init(color: .studioGreyStrokeFill, location: currentLocation),
            .init(color: .studioGreyFillCard, location: 1.21)
        ], startPoint: .leading, endPoint: .trailing)
        .frame(height: height)
        .continiousCornerRadius(.gradientCornerRadius)
    }
}

public struct WithGradientLocationTimerModifier: ViewModifier {

    @Binding var gradientLocation: CGFloat
    @State private var isMovingForward = true
    private let timer = Timer.publish(every: 0.007, on: .main, in: .default).autoconnect()

    public init(gradientLocation: Binding<CGFloat>) {
        self._gradientLocation = gradientLocation
    }

    public func body(content: Content) -> some View {
        content
            .onReceive(timer) { _ in
                gradientLocation += isMovingForward ? 0.01 : -0.01
                if gradientLocation > 1.2 {
                    isMovingForward = false
                }
                if gradientLocation < -0.2 {
                    isMovingForward = true
                }
            }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(WithGradientLocationTimerModifier(gradientLocation: .constant(0)))
}

private extension CGFloat {
    static let gradientCornerRadius: CGFloat = 8
}

#Preview {
    PlaceholderGradient(currentLocation: 1)
}
