//
//  NavigationTitle.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI

public struct NavigationTitle: View {

    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.poppins(.buttonText))
            .foregroundStyle(Color.studioBlackLight)
    }
}

#Preview {
    NavigationTitle(title: "Explore")
}
