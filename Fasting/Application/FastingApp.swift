//
//  FastingApp.swift
//  Fasting
//
//  Created by Denis Khlopin on 17.10.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

@main
struct FastingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let navigator = Navigator()

    var body: some Scene {
        WindowGroup {
            RootRoute(navigator: navigator, input: RootInput(), output: { _ in }).view
                .preferredColorScheme(.light)
        }
    }
}
