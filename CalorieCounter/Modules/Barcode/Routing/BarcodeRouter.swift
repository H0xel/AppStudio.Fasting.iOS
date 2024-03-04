//  
//  BarcodeRouter.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//

import SwiftUI
import AppStudioNavigation

class BarcodeRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: BarcodeInput,
                      output: @escaping BarcodeOutputBlock) -> Route {
        BarcodeRoute(navigator: navigator, input: input, output: output)
    }
}
