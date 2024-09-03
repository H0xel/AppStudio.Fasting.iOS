//
//  PushNotificationService.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 02.11.2023.
//

protocol PushNotificationService {
    func setPushToken(_ token: String) async
    func registerForPushNotificationsIfNeeded() async
    func handlePush(_ userInfo: [AnyHashable: Any])
}
