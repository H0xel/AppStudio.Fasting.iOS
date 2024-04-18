//  
//  ComboBoxEditorRouter.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation

class ComboBoxEditorRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: ComboBoxEditorInput,
                      output: @escaping ComboBoxEditorOutputBlock) -> Route {
        ComboBoxEditorRoute(navigator: navigator, input: input, output: output)
    }
}
