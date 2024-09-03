//
//  AppStudioTemplateApp.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 17.10.2023.
//

import SwiftUI
import AppStudioNavigation

@main
struct AppStudioTemplateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let navigator = Navigator()

    var body: some Scene {
        WindowGroup {
            navigator.initialize(route: RootRoute(navigator: navigator, input: RootInput(), output: { _ in }))
        }
    }
}
