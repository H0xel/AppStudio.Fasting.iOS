//  
//  FastingRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation

class FastingRouter: BaseRouter {
    func presentStartFastingDialog() {
        let route = StartFastingRoute(navigator: navigator, input: .init(), output: { _ in })
        present(sheet: route, detents: [.height(484)], showIndicator: false)
    }
}
