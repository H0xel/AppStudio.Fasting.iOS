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
    @Dependency(\.storageService) private var storageService
    private var step: Step {
        storageService.onboardingIsFinished ? .fasting : .onboarding
    }
    let navigator = Navigator()

    var body: some Scene {
        WindowGroup {
            navigator.initialize(route: RootRoute(navigator: navigator, input: RootInput(step: step), output: { _ in }))
        }
    }
}
