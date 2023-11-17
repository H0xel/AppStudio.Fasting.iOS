//
//  SnapCarousel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI

// To for acepting List....
@MainActor
struct SnapCarousel<Content: View, T: Hashable>: View {

    var content: (T) -> Content
    var list: [T]

    // Properties....
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int

    init(spacing: CGFloat = 16,
         trailingSpace: CGFloat = 80,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }

    // Offset...
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0

    var body: some View {
        GeometryReader { proxy in

            // Settings correct Width for snap Carousel...

            // One Sided Snap Carousel
            let width = proxy.size.width - ( trailingSpace - spacing )
            let adjustMentWidth = (trailingSpace / 2) - spacing

            HStack(spacing: spacing) {
                ForEach(list, id: \.self) { item in
                    content(item)
                        .frame(width: abs(proxy.size.width - trailingSpace))
                }
            }

            // Spacing will be horizontal padding...
            .padding(.horizontal, spacing)
            // Setting only after 0th index...
            .offset(x: (CGFloat(currentIndex) * -width) + ( currentIndex != 0 ? adjustMentWidth : 0 ) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        let maximumWidthScroll: CGFloat = 100
                        let isFirstItemLeftScroll = currentIndex == 0 && value.translation.width > maximumWidthScroll
                        let isLastItemRightScroll = currentIndex == list.count - 1 && value.translation.width < -maximumWidthScroll
                        let isDefaultScroll = currentIndex != 0 || index != list.count - 1

                        if isFirstItemLeftScroll {
                            out = maximumWidthScroll + value.translation.width / maximumWidthScroll
                            return
                        }

                        if isLastItemRightScroll {
                            out = -maximumWidthScroll - value.translation.width / maximumWidthScroll
                            return
                        }

                        if isDefaultScroll {
                            out = value.translation.width
                            return
                        }
                    })
                    .onEnded({ value in

                        // Updating Current Index....
                        let offsetX = value.translation.width

                        // Were going to convert the tranlsation into progreess ( 0 - 1 )
                        // and round the value...
                        // based on the progress increasing or decreasing the currentInde....

                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()

                        // setting max....
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)

                        // updating index....
                        currentIndex = index
                    })
                    .onChanged({ value in
                        // updating only index...

                        // Updating Current Index....
                        let offsetX = value.translation.width

                        // Were going to convert the tranlsation into progreess ( 0 - 1 )
                        // and round the value...
                        // based on the progress increasing or decreasing the currentInde....

                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()

                        // setting max....

                        let roundIndexCustom = progress.rounded(progress > 0 ? .up : .down)

                        index = max(min(currentIndex + Int(roundIndexCustom), list.count - 1), 0)
                    })
            )
        }
        // Animatiing when offset = 0
        .animation(.bouncy, value: offset == 0)
    }
}
