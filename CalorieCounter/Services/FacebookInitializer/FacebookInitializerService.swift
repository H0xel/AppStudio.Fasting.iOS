//  
//  FacebookInitializerService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 07.02.2024.
//

import UIKit

protocol FacebookInitializerService {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )
    func scene(openURLContexts URLContexts: Set<UIOpenURLContext>)
}
