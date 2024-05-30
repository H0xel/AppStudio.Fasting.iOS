//
//  CardView.swift
//
//
//  Created by Руслан Сафаргалеев on 20.05.2024.
//

import SwiftUI

public struct CardView<Content: View>: View {

    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Color.studioGreyStrokeFill
                .frame(width: .dragWidth, height: .dragHeight)
                .continiousCornerRadius(.dragCornerRadius)
                .padding(.vertical, .dragPadding)
                .animation(nil)
            content()
        }
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
        .modifier(TopBorderModifier())
    }
}

private extension CGFloat {
    static let dragWidth: CGFloat = 32
    static let dragHeight: CGFloat = 5
    static let dragCornerRadius: CGFloat = 16
    static let dragPadding: CGFloat = 6
    static let cornerRadius: CGFloat = 20
}

#Preview {
    CardView {
        Text("Hello world!")
    }
}
