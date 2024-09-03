//
//  AppDelegate.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 17.05.2023.
//

import SwiftUI
import Combine
import Dependencies

class AppDelegate: NSObject, UIApplicationDelegate {
    @Dependency(\.appInitializerService) var appInitializerService
    @Dependency(\.trackerService) var trackerService
    @Dependency(\.analyticKeyStore) var analyticKeyStore
    @Dependency(\.firstLaunchService) var firstLaunchService
    @Dependency(\.messengerService) var messenger
    @Dependency(\.storageService) var storageService
    @Dependency(\.cloudStorage) var cloudStorage
    @Dependency(\.pushNotificationService) var pushNotificationService
    private var cancellables = Set<AnyCancellable>()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        appInitializerService.initialize()
        trackLaunch()
        initializeMessageEvents()
        return true
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

// MARK: - Lifecycle

extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

// MARK: - Pushes

extension AppDelegate {
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // TODO: intercom
        // Intercom.setDeviceToken(deviceToken)
        let token = deviceToken.toFormattedPushToken
        Task {
            await pushNotificationService.setPushToken(token)
        }
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        trackerService.track(.pushDialogAnswered(isGranted: false))
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        pushNotificationService.handlePush(userInfo)
    }
}


extension AppDelegate {
    private func trackLaunch() {
        trackerService.track(.launch(firstTime: firstLaunchService.isFirstTimeLaunch,
                                     afId: analyticKeyStore.currentAppsFlyerId))
        firstLaunchService.markAsLaunched()
    }
}
