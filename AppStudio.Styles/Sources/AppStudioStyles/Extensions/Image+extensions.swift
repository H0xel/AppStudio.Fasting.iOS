//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI

public extension Image {

    /// 􀆉
    static var chevronLeft: Image {
        Image(systemName: "chevron.left")
    }

    /// 􀉪
    static var personFill: Image {
        Image(systemName: "person.fill")
    }

    /// 􀰌
    static var arrowBackward: Image {
        Image(systemName: "arrow.backward")
    }

    /// 􀑁
    static var chart: Image {
        Image(systemName: "chart.line.uptrend.xyaxis")
    }

    static var widgetInfo: Image {
        .init(.widgetInfo)
    }

    static var widgetSettings: Image {
        .init(.widgetSettings)
    }

    static var emptyGlass: Image {
        .init(.emptyGlass)
    }

    static var keyboard: Image {
        .init(.keyboard)
    }

    static var minusEx: Image {
        .init(.minus)
    }

    static var plusEx: Image {
        .init(.plus)
    }

    static var glass: Image {
        .init(.glass)
    }

    static var goal: Image {
        .init(.goal)
    }

    static var rulet: Image {
        .init(.rulet)
    }
}
