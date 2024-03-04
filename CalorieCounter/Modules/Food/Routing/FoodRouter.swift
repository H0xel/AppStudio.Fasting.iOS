//  
//  FoodRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 08.01.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class FoodRouter: BaseRouter {

    func presentFoodLogScreen(input: FoodLogInput, output: @escaping FoodLogOutputBlock) {
        let route = FoodLogRoute(navigator: navigator,
                                 input: input,
                                 output: output)
        push(route: route)
    }

    func presentTextField(onTap: @escaping() -> Void, onBarcodeScan: @escaping() -> Void) {
        present(banner: FoodLogTextFieldBanner(onTap: onTap, onBarcodeScan: onBarcodeScan))
    }

    func presentPaywall(context: PaywallContext, output: @escaping ViewOutput<PaywallScreenOutput>) {
        let route = UsagePaywallRoute(navigator: navigator,
                                      context: context,
                                      output: output)
        present(route: route)
    }

    func presentDiscountPaywall(input: DiscountPaywallInput, output: @escaping DiscountPaywallOutputBlock) {
        let route = DiscountPaywallRoute(navigator: navigator, input: input, output: output)
        present(route: route)
    }
}
