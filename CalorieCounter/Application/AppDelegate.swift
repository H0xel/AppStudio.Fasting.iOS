//
//  AppDelegate.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 17.05.2023.
//

import SwiftUI
import Combine
import Dependencies
import FacebookCore

class AppDelegate: NSObject, UIApplicationDelegate {
    @Dependency(\.appInitializerService) var appInitializerService
    @Dependency(\.trackerService) var trackerService
    @Dependency(\.analyticKeyStore) var analyticKeyStore
    @Dependency(\.firstLaunchService) var firstLaunchService
    @Dependency(\.messengerService) var messenger
    @Dependency(\.storageService) var storageService
    @Dependency(\.cloudStorage) var cloudStorage
    @Dependency(\.quickActionTypeServiceService) private var quickActionTypeServiceService
    @Dependency(\.facebookInitializerService) private var facebookInitializerService
    private var cancellables = Set<AnyCancellable>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        appInitializerService.initialize()
        trackLaunch()
        facebookInitializerService.application(application, didFinishLaunchingWithOptions: launchOptions)
        initializeMessageEvents()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            quickActionTypeServiceService.set(.init(rawValue: shortcutItem.type))
        }

        let sceneConfiguration = UISceneConfiguration(
            name: "Default",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self

        return sceneConfiguration
    }

    private func initializeMessageEvents() {
        let messenger = messenger
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [unowned self] _ in messenger.publishWillTerminateMessage(sender: self) }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [unowned self] _ in messenger.publishAppActivationMessage(sender: self) }
            .store(in: &cancellables)
    }
}

extension AppDelegate {
    private func trackLaunch() {
        trackerService.track(.launch(firstTime: firstLaunchService.isFirstTimeLaunch,
                                     afId: analyticKeyStore.currentAppsFlyerId))
        firstLaunchService.markAsLaunched()
    }
}