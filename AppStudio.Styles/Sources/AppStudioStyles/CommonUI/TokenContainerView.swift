//
//  TokenContainerView.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI

public struct TokenContainerView<Content: View, Token: Hashable>: View {

    let tokens: [Token]
    @ViewBuilder let content: (Token) -> Content

    @State private var totalHeight: CGFloat = 0
    private let tokenPadding: CGFloat = 4

    public init(tokens: [Token], @ViewBuilder content: @escaping (Token) -> Content) {
        self.tokens = tokens
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            var width = CGFloat.zero
            var height = CGFloat.zero
            var lastTokenHeight = CGFloat.zero
            var lastHeight = CGFloat.zero

            ZStack(alignment: .topLeading) {
                ForEach(tokens, id: \.self) { token in
                    content(token)
                        .alignmentGuide(.leading) { dimension in
                            if abs(width - dimension.width) > geo.size.width {
                                width = 0
                                height -= lastHeight + tokenPadding
                            }
                            lastHeight = dimension.height
                            let result = width
                            if token == tokens.last {
                                width = 0
                                lastTokenHeight = dimension.height
                            } else {
                                width -= dimension.width + tokenPadding
                            }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if token == tokens.last {
                                DispatchQueue.main.async { [height] in
                                    self.totalHeight = abs(height) + lastTokenHeight
                                }
                                height = 0
                            }
                            return result
                        }
                }
            }
        }
        .frame(height: totalHeight)
    }
}
