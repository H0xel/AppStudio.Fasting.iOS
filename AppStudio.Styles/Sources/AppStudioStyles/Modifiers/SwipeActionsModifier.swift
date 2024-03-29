//
//  SwipeActionsModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 29.03.2024.
//

import SwiftUI
import Combine
import AppStudioUI

struct SwipeActionsModifier: ViewModifier {

    var leftActions: [SwipeAction] = []
    var rightActions: [SwipeAction] = []
    @GestureState private var gestureOffset: CGFloat = 0
    @State private var buttonWidth: CGFloat = 0
    @State private var swipeOffset: CGFloat = 0
    private let id = UUID().uuidString
    @State private var feedbackGenerator: UIImpactFeedbackGenerator?
    @State private var impactOccurred = false

    func body(content: Content) -> some View {
        ZStack {
            actionsView(leftActions, position: .left)
                .opacity(totalOffset > 0 ? 1 : 0)
            actionsView(rightActions, position: .right)
                .opacity(totalOffset >= 0 ? 0 : 1)

            content
                .frame(maxWidth: .infinity)
                .offset(x: gestureOffset + swipeOffset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($gestureOffset) { value, state, _ in
                            let translation = value.translation.width
                            if translation < 0 && !rightActions.isEmpty ||
                                translation > 0 && !leftActions.isEmpty ||
                                translation > 0 && swipeOffset < 0 ||
                                translation < 0 && swipeOffset > 0 {
                                state = value.translation.width
                            }
                        }
                        .onChanged { value in
                            if feedbackGenerator == nil, !impactOccurred {
                                feedbackGenerator = .init(style: .soft)
                                feedbackGenerator?.prepare()
                            }
                            let translation = abs(value.translation.width + swipeOffset)
                            buttonWidth = translation
                            if !leftActions.isEmpty && buttonWidth > leftButtonsWidth ||
                                !rightActions.isEmpty && buttonWidth > rightButtonsWidth {
                                feedbackImpactOccured()
                            }
                        }
                        .onEnded { value in
                            let translation = value.translation.width

                            if swipeOffset == 0 {
                                if translation > 60, !leftActions.isEmpty {
                                    buttonWidth = leftButtonsWidth
                                    swipeOffset = leftButtonsWidth
                                    notifyAboutSwipe()
                                    feedbackImpactOccured()
                                } else if translation < -60, !rightActions.isEmpty {
                                    buttonWidth = rightButtonsWidth
                                    swipeOffset = -rightButtonsWidth
                                    notifyAboutSwipe()
                                    feedbackImpactOccured()
                                } else {
                                    reset()
                                }
                            } else {
                                reset()
                            }
                        }
                    )
        }
        .animation(.easeInOut(duration: 0.2), value: gestureOffset)
        .onReceive(SwipeActionsState.shared.swipePublisher) { swipeId in
            if swipeId != id {
                reset()
            }
        }
        .onDisappear {
            reset()
        }
    }

    var leftButtonsWidth: CGFloat {
        leftActions.reduce(0) { $0 + $1.buttonWidth }
    }

    var rightButtonsWidth: CGFloat {
        rightActions.reduce(0) { $0 + $1.buttonWidth }
    }

    var totalOffset: CGFloat {
        gestureOffset + swipeOffset
    }

    private func feedbackImpactOccured() {
        feedbackGenerator?.impactOccurred()
        impactOccurred = true
        feedbackGenerator = nil
    }

    private func reset() {
        withAnimation(.bouncy) {
            buttonWidth = 0
            swipeOffset = 0
        }
        impactOccurred = false
        feedbackGenerator = nil
    }

    private func notifyAboutSwipe() {
        SwipeActionsState.shared.didSwipe(from: id)
    }

    @ViewBuilder
    private func actionsView(_ actions: [SwipeAction],
                             position: AlignedViewPosition) -> some View {
        if !actions.isEmpty {
            HStack(spacing: .zero) {
                ForEach(actions) { action in
                    ZStackWith(color: action.backgroundColor) {
                        buttonView(action: action)
                            .fixedSize()
                            .frame(width: action.buttonWidth)
                    }
                }
            }
            .frame(maxWidth: buttonWidth)
            .continiousCornerRadius(20)
            .aligned(position)
        }
    }

    private func buttonView(action: SwipeAction) -> some View {
        Button(action: action.action) {
            VStack(spacing: 2) {
                if let image = action.image {
                    image
                }
                if let text = action.title {
                    Text(text)
                        .font(.footnote)
                }
            }
            .padding(4)
            .foregroundColor(action.foregroundColor)
            .multilineTextAlignment(.center)
        }
    }
}

private class SwipeActionsState {
    static let shared = SwipeActionsState()
    private let swipeSubject = PassthroughSubject<String, Never>()
    private init() {}

    var swipePublisher: AnyPublisher<String, Never> {
        swipeSubject.eraseToAnyPublisher()
    }

    func didSwipe(from id: String) {
        swipeSubject.send(id)
    }
}

public extension View {
    func withSwipeActions(leftActions: [SwipeAction] = [],
                          rightActions: [SwipeAction] = []) -> some View {
        modifier(SwipeActionsModifier(leftActions: leftActions, rightActions: rightActions))
    }

    func withLeftSwipeActions(_ actions: [SwipeAction]) -> some View {
        modifier(SwipeActionsModifier(leftActions: actions))
    }

    func withRightSwipeActions(_ actions: [SwipeAction]) -> some View {
        modifier(SwipeActionsModifier(rightActions: actions))
    }
}

