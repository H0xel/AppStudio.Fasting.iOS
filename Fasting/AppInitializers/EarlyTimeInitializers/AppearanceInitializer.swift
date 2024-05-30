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
        let tabBarAppearence = UITabBarAppearance()
        tabBarAppearence.configureWithTransparentBackground()
        tabBarAppearence.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearence
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearence
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.studioGreyStrokeFill)

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}
