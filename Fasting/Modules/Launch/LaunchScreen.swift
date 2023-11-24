//
//  LaunchScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 22.11.2023.
//

import SwiftUI
import AppStudioUI

struct LaunchScreen: View {
    var body: some View {
        ZStackWith(color: Color.white) {
            Image("fasting-launchscreen-icon")
                .resizable()
                .frame(width: Layout.size, height: Layout.size)
                .continiousCornerRadius(Layout.cornerRadius)
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
