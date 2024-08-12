//  
//  CustomProductRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class CustomProductRouter: BaseRouter {

    func presentToolbar(items: [ToolbarAction], action: @escaping (ToolbarAction) -> Void) {
        let banner = ToolbarBanner(items: items, onTap: action)
        present(banner: banner)
    }

    func presentCustomFood(context: CustomFoodInput.Context, output: @escaping CustomFoodOutputBlock) {
        let route = CustomFoodRoute(navigator: navigator,
                                    input: .init(context: context),
                                    output: output)
        present(route: route)
    }

    func presentKeyboard(input: CustomKeyboardInput,
                         animation: Animation?,
                         output: @escaping ViewOutput<LogProductKeyboardOutput>) {
        let banner = LogProductKeyboardBanner(input: input, output: output)
        present(banner: banner, animation: animation)
    }
}
