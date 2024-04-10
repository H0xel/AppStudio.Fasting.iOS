//
//  AppearanceInitializer.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.11.2023.
//

import Foundation
import SwiftUI
import AppStudioStyles

class AppearanceInitializer: AppInitializer {
    func initialize() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.studioGreyStrokeFill)
        UITabBar.appearance().backgroundColor = UIColor.white
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
