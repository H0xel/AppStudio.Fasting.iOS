//
//  SnapCarousel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 09.01.2024.
//

import SwiftUI
import MunicornUtilities

struct SnapCarousel<Content: View, T: Hashable>: View {
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var currentItem: T

    init(spacing: CGFloat = 16,
         trailingSpace: CGFloat = 64,
         currentItem: Binding<T>,
         items: [T],
         @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._currentItem = currentItem
        self.content = content
    }

    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex: Int = 1

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - ( trailingSpace - spacing )
            let adjustMentWidth = (trailingSpace / 2) - spacing

            HStack(spacing: spacing) {
                ForEach(list, id: \.self) { item in
                    content(item)
                        .padding(.leading, item == list.first ? spacing : 0)
                        .frame(width: abs(proxy.size.width - trailingSpace))
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + ( currentIndex != 0 ? adjustMentWidth : 0 ) + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded(progress > 0 ? .up : .down)
                        let index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentItem = list[index]
                    }
            )
        }
        .animation(.easeInOut, value: offset)
    }
}
