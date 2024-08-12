//
//  CloseButton.swift
//
//
//  Created by Руслан Сафаргалеев on 24.07.2024.
//

import SwiftUI

public struct CloseButton: View {

    public init() {}

    public var body: some View {
        Image.xmarkUnfilled
            .foregroundStyle(Color.studioBlackLight)
    }
}

public extension View {
    func closeButton(action: @escaping () -> Void) -> some View {
        self
            .navBarButton(content: CloseButton(), action: action)
    }
}

#Preview {
    CloseButton()
}
