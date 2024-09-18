//
//  OnboardingCustomSlider.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.01.2024.
//

import SwiftUI

struct OnboardingCustomSlider: View {
    @State private var lastPosition: CGSize = .init(width: 50, height: 0)
    @GestureState private var gestureState: CGFloat = 0

    @Binding var startPoint: CGFloat
    let outsideRange: ClosedRange<Double>
    let insideRange: ClosedRange<Double>

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Divider()
                    .frame(height: .dividerHeight)
                    .background(Color.studioGreyStrokeFill)
                    .padding(.horizontal, .horizontalPadding)

                Divider()
                    .frame(height: .dividerHeight)
                    .background(Color.studioGreen)
                    .padding(.leading, leftPadding(width: proxy.size.width))
                    .padding(.trailing, rightPadding(width: proxy.size.width))

                HStack {
                    Circle()
                        .frame(width: .circleFrame, height: .circleFrame)
                        .foregroundColor(.black)
                        .offset(x: currentOffset(width: proxy.size.width))
                        .gesture(
                            DragGesture()
                                .updating($gestureState) { value, state, _ in
                                    state = value.translation.width
                                }
                                .onChanged { value in
                                    let lastPosition = calculateLastPosition(value: value, width: proxy.size.width)
                                    updateStartPoint(width: proxy.size.width, lastPosition: lastPosition)
                                }
                                .onEnded { value in
                                    lastPosition = calculateLastPosition(value: value, width: proxy.size.width)
                                    updateStartPoint(width: proxy.size.width, lastPosition: lastPosition)
                                }
                        )
                    Spacer()
                }
            }
            .onAppear {
                updateLastPosition(width: proxy.size.width)
            }
        }
    }

    private func calculateLastPosition(value: GestureStateGesture<DragGesture, CGFloat>.Value,
                                       width: CGFloat) -> CGSize {
        var offset = lastPosition.width + value.translation.width
        if value.location.x < 0 {
            offset = 0
        }

        if value.location.x > width {
            offset = width
        }
        return CGSize(width: offset, height: 0)
    }

    private func leftPadding(width: CGFloat) -> CGFloat {
        let range: ClosedRange<CGFloat> = 0...width
        let padding = insideRange.lowerBound.scale(from: outsideRange, to: range)
        return padding
    }

    private func rightPadding(width: CGFloat) -> CGFloat {
        let range: ClosedRange<CGFloat> = 0...width
        let padding = insideRange.upperBound.scale(from: outsideRange, to: range)
        return width - padding
    }

    private func currentOffset(width: CGFloat) -> CGFloat {
        let offset = gestureState + (lastPosition.width - CGFloat.halfCircle)
        return offset < 0 ? 0 : offset > width - .circleFrame ? width - .circleFrame : offset
    }

    private func updateStartPoint(width: CGFloat, lastPosition: CGSize) {

        if lastPosition.width.scale(from: 0...width, to: outsideRange) < outsideRange.lowerBound {
            startPoint = outsideRange.lowerBound
            return
        }

        if lastPosition.width.scale(from: 0...width, to: outsideRange) > outsideRange.upperBound {
            startPoint = outsideRange.upperBound
            return
        }

        startPoint = lastPosition.width.scale(from: 0...width, to: outsideRange)
    }

    private func updateLastPosition(width: CGFloat) {
        let offset = startPoint.scale(from: outsideRange, to: 0...width)
        lastPosition = .init(width: offset, height: 0)
    }
}

private extension CGFloat {
    static var dividerHeight: CGFloat { 4 }
    static var circleFrame: CGFloat { 40 }
    static var halfCircle: CGFloat { circleFrame / 2 }
    static var horizontalPadding: CGFloat { 16 }
}

#Preview {
    OnboardingCustomSlider(
        startPoint: .constant(0.503),
        outsideRange: 0.5...1.1,
        insideRange: 0.6...0.9)
        .padding(.horizontal, 32)
}
