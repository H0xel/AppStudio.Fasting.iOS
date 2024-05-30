//
//  CoachSuggestionsView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import SwiftUI
import Dependencies
import MunicornUtilities
import AppStudioUI

struct CoachSuggestionsView: View {

    @Dependency(\.styles) private var styles

    let suggestions: [String]
    let maxPosition: CGFloat
    let isPresented: Bool
    let regenerate: () -> Void
    let onTap: (String) -> Void

    @GestureState private var dragOffset: CGFloat = 0
    @State private var currentOffset: CGFloat = 0
    @State private var stackHeight: CGFloat = 0
    @State private var currentPosition: CGFloat = 0
    @State private var feedbackGenerator: UIImpactFeedbackGenerator?
    @State private var seenSuggestions: Set<String> = []
    @State private var didVibrate = false
    @State private var maxOffset: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            CoachSuggestionsTitleView(styles: styles, onTap: regenerate)
                .padding(.bottom, .titleBottomPadding)
                .padding(.bottom, .spacing)
                .animation(nil, value: displayedSuggestions)
            ScrollView(.vertical) {
                CoachSuggestionsStackView(suggestions: displayedSuggestions,
                                          styles: styles,
                                          onTap: onTap)
                .animation(.bouncy, value: additionalItems)
                .aligned(.left)
                MinYPositionTracker(coordinateSpace: .named("CoachSuggestionsViewScrollView")) { newValue in
                    if dragOffset == 0, currentOffset == 0 {
                        stackHeight = newValue - 8
                    }
                }
            }
            .coordinateSpace(name: "CoachSuggestionsViewScrollView")
            .scrollIndicators(.hidden)
            .scrollDisabled(!isTopReached)
            .frame(maxHeight: max(0, currentOffset + dragOffset + stackHeight))
            .animation(nil, value: displayedSuggestions)
        }
        .padding(.horizontal, .horizontalPadding)
        .padding(.bottom, .bottomPadding)
        .padding(.top, .topPadding)
        .background(.white)
        .highPriorityGesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragOffset) { value, state, _ in
                    if currentOffset - value.translation.height < 0 {
                        state = -currentOffset
                        return
                    }
                    let difference = -value.translation.height - state
                    state = -value.translation.height - max(0, maxPosition - (currentPosition - difference))
                }
                .onChanged { value in
                    if currentOffset - value.translation.height < 0, !didVibrate {
                        vibrate()
                        didVibrate = true
                    }
                }
                .onEnded { value in
                    if maxOffset > 0 {
                        currentOffset = min(maxOffset, max(0, currentOffset - value.translation.height))
                    } else {
                        currentOffset = max(0, currentOffset - value.translation.height)
                        if value.location.y < maxPosition {
                            currentOffset -= maxPosition - value.location.y
                        }
                    }
                    didVibrate = false
                }
        )
        .onChange(of: suggestions) { newValue in
            displayedSuggestions.forEach { seenSuggestions.insert($0) }
            if newValue.count - seenSuggestions.count <= 3 {
                seenSuggestions = []
            }
            withAnimation(.bouncy) {
                currentOffset = 0
            }
        }
        .overlay(
            MinYPositionTracker(coordinateSpace: .global) { newValue in
                currentPosition = newValue
                if currentOffset == 0, dragOffset == 0 {
                    maxOffset = newValue - maxPosition
                }
            }
            .aligned(.top)
        )
        .onChange(of: isTopReached) { isTopReached in
            if dragOffset != 0 {
                vibrate()
            }
        }
        .onChange(of: isPresented) { newValue in
            currentOffset = 0
        }
        .animation(.bouncy, value: displayedSuggestions)
        .id(maxPosition)
    }

    private func vibrate() {
        feedbackGenerator = .init(style: .soft)
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
    }

    private var isTopReached: Bool {
        if maxPosition <= 0 {
            return false
        }
        return currentPosition <= maxPosition
    }

    private var displayedSuggestions: [String] {
        if isTopReached {
            return suggestions
        }
        return Array(suggestions.filter { !seenSuggestions.contains($0) }.prefix(3 + additionalItems))
    }

    var additionalItems: Int {
        max(0, Int(dragOffset + currentOffset) / 50)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
    static let horizontalPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 12
    static let topPadding: CGFloat = 16
    static let titleBottomPadding: CGFloat = 4
    static let dragAreaHeight: CGFloat = 23
    static let lineWidth: CGFloat = 32
    static let lineHeight: CGFloat = 2
    static let lineCornerRadius: CGFloat = 8
}

#Preview {
    ZStack {
        Color.red
        CoachSuggestionsView(suggestions: [
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snacks can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snacks can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snacks can help me stay full?",
            "Can you help me with a workout plan?",
            "Tips to manage social eating pressure? What to eat before exercise?",
            "What meals/snacks can help me stay full?",
            "Can you help me with a workout plan?"
        ], maxPosition: 20, 
                             isPresented: true) {} onTap: { _ in }
            .background(.white)
            .aligned(.bottom)
    }
}
