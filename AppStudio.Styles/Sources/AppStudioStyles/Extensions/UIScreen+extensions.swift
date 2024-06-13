//
//  UIScreen+extensions.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import UIKit

public extension UIScreen {
    static var isSmallDevice: Bool {
        UIScreen.main.bounds.height <= 667
    }

    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
