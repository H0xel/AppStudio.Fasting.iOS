//  
//  DoubleValueEditorRouter.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//

import SwiftUI
import AppStudioNavigation

class DoubleValueEditorRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: DoubleValueEditorInput,
                      output: @escaping DoubleValueEditorOutputBlock) -> Route {
        DoubleValueEditorRoute(navigator: navigator, input: input, output: output)
    }
}
