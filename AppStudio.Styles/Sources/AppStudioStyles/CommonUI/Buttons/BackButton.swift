//
//  BackButton.swift
//
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI
import AppStudioUI

public struct BackButton: View {

    public init() {}

    public var body: some View {
        Image.chevronLeft
            .foregroundStyle(Color.studioBlackLight)
    }
}

public extension View {
    func backButton(action: @escaping () -> Void) -> some View {
        self
            .navBarButton(content: BackButton(), action: action)
    }
}

#Preview {
    BackButton()
}
