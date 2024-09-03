//
//  PushNotificationServiceImpl.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 02.11.2023.
//

import UIKit
import UserNotifications
import RxSwift
import Dependencies
import CocoaLumberjackSwift

final class PushNotificationServiceImpl: NSObject, PushNotificationService {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.trackerService) private var tracker
    @Dependency(\.accountApi) private var accountApi

    private let application = UIApplication.shared
    private let disposeBag = DisposeBag()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self

        Task {
            await updatePushNotificationsGrantedState()
        }

        // in case app was allowed to receive pushes from Settings app
        Observable.combineLatest(messenger.onMessage(AppWillEnterForegroundMessage.self),
                                 messenger.onReplayMessage(AppInitializedMessage.self))
        .subscribe(with: self) { this, _ in
            this.queryPushTokenIfRegistered(checkingState: true)
        }
        .disposed(by: disposeBag)
    }

    func setPushToken(_ token: String) async {
        do {
            try await accountApi.putPushToken(PutPushTokenRequest(token: token))
        } catch let error {
            DDLogError("Set push token error: \(error.localizedDescription)")
        }
    }

    func registerForPushNotificationsIfNeeded() async {
        let isGranted = storageService.isPushNotificationsPermissionGranted
        if isGranted == nil {
            await registerForPushNotifications()
        } else if isGranted == true {
            queryPushTokenIfRegistered(checkingState: false)
        }
    }

    func handlePush(_ userInfo: [AnyHashable: Any]) {
        // TODO: when intercom integrated
        // if Intercom.isIntercomPushNotification(notification) {
        //     Intercom.handlePushNotification(notification)
        //     return
        // }
        guard let push = userInfo.pushValue else {
            return
        }

        if application.applicationState == .active {
            messenger.publishPushReceivedMessage(push: push, isInForeground: true)
        } else {
            application.applicationIconBadgeNumber = push.aps.badge ?? (application.applicationIconBadgeNumber + 1)
            messenger.publishPushReceivedMessage(push: push, isInForeground: false)
        }
    }

    private func registerForPushNotifications() async {
        do {
            let isGranted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            if isGranted {
                self.tracker.track(.pushDialogAnswered(isGranted: true))
                queryPushTokenIfRegistered(checkingState: false)
            } else {
                let settings = await UNUserNotificationCenter.current().notificationSettings()

                if settings.authorizationStatus == .denied {
                    self.tracker.track(.pushDialogAnswered(isGranted: true))
                }
            }
            await updatePushNotificationsGrantedState()
        } catch let error {
            DDLogDebug("failed to register remote notifications :\(error.localizedDescription)")
            await updatePushNotificationsGrantedState()
        }
    }

    private func updatePushNotificationsGrantedState() async {
        self.storageService.isPushNotificationsPermissionGranted = await pushNotificationGrantedState()
        self.storageService.synchronize()
    }

    private func pushNotificationGrantedState() async -> Bool? {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        var isGranted: Bool?
        switch settings.authorizationStatus {
        case .authorized:
            isGranted = true
        case .denied:
            isGranted = false
        case .notDetermined:
            isGranted = nil
        case .ephemeral, .provisional:
            assertionFailure("Check future behaviour")
        @unknown default:
            assertionFailure("Check future behaviour")
        }

        return isGranted
    }

    private func queryPushTokenIfRegistered(checkingState: Bool) {
        Task.detached { @MainActor in
            if checkingState {
                if await self.pushNotificationGrantedState() == true {
                    // this queries push token from app and delivers it in AppDelegate
                    self.application.registerForRemoteNotifications()
                }
            } else {
                self.application.registerForRemoteNotifications()
            }
        }
    }
}

extension PushNotificationServiceImpl: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {

        handlePush(response.notification.request.content.userInfo)
        completionHandler()
    }

    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
        ) -> Void) {
        handlePush(notification.request.content.userInfo)
        completionHandler([.badge, .sound])
    }
}
