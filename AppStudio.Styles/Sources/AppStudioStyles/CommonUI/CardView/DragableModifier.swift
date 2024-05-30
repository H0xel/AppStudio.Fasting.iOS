//
//  DragableModifier.swift
//
//
//  Created by Руслан Сафаргалеев on 20.05.2024.
//

import SwiftUI

public struct DragableModifier: ViewModifier {

    @GestureState private var dragOffset: CGFloat = 0
    @State private var topPadding: CGFloat = 0
    @State private var viewHeight: CGFloat = 0

    private let isCollapsed: Bool
    private let minTopPadding: CGFloat
    private let bottomPadding: CGFloat
    private let onChangeCollapsed: (Bool) -> Void
    private let onDraging: ((Bool) -> Void)?

    public init(isCollapsed: Bool,
                minTopPadding: CGFloat = 0,
                bottomPadding: CGFloat = 0,
                onChangeCollapsed: @escaping (Bool) -> Void,
                onDraging: ((Bool) -> Void)? = nil) {
        self.isCollapsed = isCollapsed
        self.minTopPadding = minTopPadding
        self.bottomPadding = bottomPadding
        self.onChangeCollapsed = onChangeCollapsed
        self.onDraging = onDraging
    }

    public func body(content: Content) -> some View {
        content
            .offset(y: max(0, dragOffset + topPadding))
            .withViewHeightPreferenceKey
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($dragOffset) { value, state, _ in
                        state = min(value.translation.height, maxOffset)
                    }
                    .onChanged { _ in
                        onDraging?(true)
                    }
                    .onEnded { value in
                        onDraging?(false)
                        topPadding = max(0, min(topPadding + value.translation.height,
                                                maxHeight))
                        toggleCollapsed(value.translation.height > 0)
                        onChangeCollapsed(value.translation.height > 0)
                    }
            )
            .onViewHeightPreferenceKeyChange { newHeight in
                let height = viewHeight
                viewHeight = newHeight
                if isCollapsed {
                    topPadding += newHeight - height
                }
            }
            .padding(.top, minTopPadding)
            .onChange(of: isCollapsed) { newValue in
                toggleCollapsed(newValue)
            }
            .onAppear {
                toggleCollapsed(isCollapsed, animation: nil)
            }
            .onChange(of: bottomPadding) { bottomPadding in
                if isCollapsed {
                    topPadding = viewHeight - bottomPadding
                }
            }
    }

    private func toggleCollapsed(_ isCollapsed: Bool,
                                 animation: Animation? = .linear(duration: 0.2)) {
        withAnimation(animation) {
            if isCollapsed {
                topPadding = maxHeight
            } else {
                topPadding = 0
            }
        }
    }

    private var maxHeight: CGFloat {
        viewHeight - bottomPadding
    }

    private var maxOffset: CGFloat {
        viewHeight - topPadding - bottomPadding
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(DragableModifier(isCollapsed: false) { _ in } )
}
