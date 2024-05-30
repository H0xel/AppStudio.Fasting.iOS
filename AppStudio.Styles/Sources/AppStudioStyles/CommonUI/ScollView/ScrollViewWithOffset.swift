//
//  ScrollViewWithOffset.swift
//
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI

public struct ScrollViewWithOffset<Content: View>: View {
    let content: () -> Content
    let onOffsetChange: (CGFloat) -> Void

    public init(
        @ViewBuilder content: @escaping () -> Content,
        onOffsetChange: @escaping (CGFloat) -> Void
    ) {
        self.content = content
        self.onOffsetChange = onOffsetChange
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            offsetReader
            content()
                .padding(.top, -8) // 👈🏻 places the real content as if our `offsetReader` was not there.
        }
        .coordinateSpace(name: coordinatorSpaceName)
        .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChange)
    }

    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named(coordinatorSpaceName)).minY
                )
        }
        .frame(height: 0) // 👈🏻 make sure that the reader doesn't affect the content height
    }
}

private var coordinatorSpaceName = "ScrollViewWithOffset"

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
