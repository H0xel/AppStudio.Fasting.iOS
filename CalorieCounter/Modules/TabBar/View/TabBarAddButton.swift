//
//  TabBarAddButton.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI

struct TabBarAddButton: View {

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Image(.tabBarRainbow)
                Image.plus
                    .resizable()
                    .frame(width: .plusHeight, height: .plusHeight)
                    .foregroundStyle(.white)
            }
        }
    }
}

private extension CGFloat {
    static let plusHeight: CGFloat = 20
}

#Preview {
    TabBarAddButton {}
}
