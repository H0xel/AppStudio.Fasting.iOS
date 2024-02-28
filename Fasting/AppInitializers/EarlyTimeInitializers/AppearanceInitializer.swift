//
//  AppearanceInitializer.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.11.2023.
//

import Foundation
import SwiftUI

class AppearanceInitializer: AppInitializer {
    func initialize() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.fastingGreyStrokeFill)
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
