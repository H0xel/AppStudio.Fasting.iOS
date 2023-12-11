//
//  Image+extensions.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI

extension Image {

    static var heart: Image {
        Image("heart")
    }

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

    /// 􀯶
    static var chevronLeft: Image {
        Image(systemName: "chevron.backward")
    }

    /// 􀆄
    static var xmark: Image {
        Image(systemName: "xmark")
    }

    /// 􀐬
    static var clockFill: Image {
        Image(systemName: "clock.fill")
    }

    /// 􀟉
    static var diamondFill: Image {
        Image(systemName: "diamond.fill")
    }

    /// 􀎡
    static var lockFill: Image {
        Image(systemName: "lock.fill")
    }
}
