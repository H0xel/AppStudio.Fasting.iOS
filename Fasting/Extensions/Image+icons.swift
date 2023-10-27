//
//  Image+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

extension Image {
    static var fastingTabBarItemActive: Image {
        Image("fastingTabBarItemActive")
    }

    static var fastingTabBarItemInactive: Image {
        Image("fastingTabBarItemInactive")
    }

    static var pen: Image {
        Image("pen")
    }

    /// 􀉪
    static var personFill: Image {
        Image(systemName: "person.fill")
    }

    /// 􀦆
    static var crownFill: Image {
        Image(systemName: "crown.fill")
    }
}
