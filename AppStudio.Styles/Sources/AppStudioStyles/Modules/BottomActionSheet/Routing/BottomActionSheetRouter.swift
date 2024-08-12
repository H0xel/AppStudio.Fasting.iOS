//  
//  BottomActionSheetRouter.swift
//  
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI
import AppStudioNavigation

class BottomActionSheetRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: BottomActionSheetInput,
                      output: @escaping BottomActionSheetOutputBlock) -> Route {
        BottomActionSheetRoute(navigator: navigator, input: input, output: output)
    }
}
