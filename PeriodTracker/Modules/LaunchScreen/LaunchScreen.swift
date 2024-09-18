//
//  LaunchScreen.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import SwiftUI
import AppStudioUI

struct LaunchScreen: View {
    var body: some View {
        ZStackWith(color: Color.white) {
            Image(.launchScreenIcon)
                .resizable()
                .frame(width: Layout.size, height: Layout.size)
                .continiousCornerRadius(Layout.cornerRadius)
                .shadow(color: .black, radius: 5)
        }
        .navigationBarHidden(true)
    }
}

extension LaunchScreen {
    enum Layout {
        static let cornerRadius: CGFloat = 20
        static let size: CGFloat = 100
    }
}

#Preview {
    LaunchScreen()
}
