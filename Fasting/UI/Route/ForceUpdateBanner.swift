//
//  ForceUpdateRoute.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 02.11.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct ForceUpdateBanner: Banner {

    let onUpdate: () -> Void

    var view: AnyView {
        ForceUpdateScreen(theme: .init(), onUpdate: onUpdate)
            .eraseToAnyView()
    }
}
