//
//  CalorieCounterApp.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.10.2023.
//

import SwiftUI
import AppStudioNavigation

@main
struct CalorieCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootRoute(navigator: .init(), input: .init(), output: { _ in }).view
                .preferredColorScheme(.light)
        }
    }
}
