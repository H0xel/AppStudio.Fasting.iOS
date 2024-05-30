//
//  BackButton.swift
//
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI

public struct BackButton: View {

    public init() {}

    public var body: some View {
        Image.chevronLeft
            .foregroundStyle(Color.studioBlackLight)
    }
}

#Preview {
    BackButton()
}
