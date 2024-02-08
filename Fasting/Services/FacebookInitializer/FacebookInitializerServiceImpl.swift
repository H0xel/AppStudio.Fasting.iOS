//  
//  FacebookInitializerServiceImpl.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 07.02.2024.
//

import FacebookCore

class FacebookInitializerServiceImpl: FacebookInitializerService {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    func scene(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
