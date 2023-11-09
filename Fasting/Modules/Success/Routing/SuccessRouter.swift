//  
//  SuccessRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioNavigation

class SuccessRouter: BaseRouter {
    func presentEditFastingTime(input: StartFastingInput, output: @escaping StartFastingOutputBlock) {
        let route = StartFastingRoute(navigator: navigator,
                                      input: input,
                                      output: output)
        present(sheet: route, detents: [.height(484)])
    }
}
