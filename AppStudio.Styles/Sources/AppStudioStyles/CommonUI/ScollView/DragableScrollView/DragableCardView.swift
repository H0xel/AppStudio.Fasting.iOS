//
//  DragableCardView.swift
//
//
//  Created by Руслан Сафаргалеев on 15.05.2024.
//

import SwiftUI
import AppStudioUI

public struct DragableCardView<Content: View>: View {

    private let isCollapsed: Bool
    @Binding private var scrollViewOffset: CGFloat
    private let viewId: UUID
    private let minTopPadding: CGFloat
    private let bottomPadding: CGFloat

    private let onChangeCollapsed: (Bool) -> Void
    private let content: () -> Content

    @State private var dragScrollViewOffset: CGFloat = 0
    @State private var contentOffset: CGFloat = .zero
    @State private var isDraggingScrollView = false

    public init(scrollViewOffset: Binding<CGFloat>,
                isCollapsed: Bool,
                viewId: UUID,
                minTopPadding: CGFloat = 0,
                bottomPadding: CGFloat = 0,
                onChangeCollapsed: @escaping (Bool) -> Void,
                @ViewBuilder content: @escaping () -> Content) {
        self._scrollViewOffset = scrollViewOffset
        self.viewId = viewId
        self.content = content
        self.onChangeCollapsed = onChangeCollapsed
        self.isCollapsed = isCollapsed
        self.minTopPadding = minTopPadding
        self.bottomPadding = bottomPadding
    }

    public var body: some View {
        CardView {
            DragableScrollView(isDragging: $isDraggingScrollView,
                               dragOffset: $dragScrollViewOffset,
                               scrollOffset: $scrollViewOffset,
                               contentOffset: $contentOffset,
                               content: content)
            .id(viewId)
        }
        .modifier(DragableModifier(isCollapsed: isCollapsed,
                                   minTopPadding: minTopPadding + contentOffset,
                                   bottomPadding: bottomPadding,
                                   onChangeCollapsed: onChangeCollapsed))
        .onChange(of: isDraggingScrollView) { isDragging in
            if !isDragging, contentOffset > 0 {
                onChangeCollapsed(contentOffset > 50)
            }
            if contentOffset <= 50 {
                withAnimation(.bouncy) {
                    dragScrollViewOffset = 0
                    contentOffset = 0
                }
            }
        }
        .onChange(of: dragScrollViewOffset) { newValue in
            guard isDraggingScrollView else {
                contentOffset = 0
                dragScrollViewOffset = 0
                return
            }
            contentOffset = max(0, contentOffset + newValue)
        }
        .onChange(of: isCollapsed) { newValue in
            dragScrollViewOffset = 0
            contentOffset = 0
        }
    }
}

#Preview {
    DragableCardView(scrollViewOffset: .constant(0),
                     isCollapsed: false,
                     viewId: .init(),
                     onChangeCollapsed: { _ in },
                     content: { Text("") })
}
