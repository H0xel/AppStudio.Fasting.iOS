//
//  UIScreen+extensions.swift
//  Fasting
//
//  Created by Amakhin Ivan on 28.11.2023.
//

import UIKit

extension UIScreen {
    static var isSmallDevice: Bool {
        UIScreen.main.bounds.height <= 667
    }
}
